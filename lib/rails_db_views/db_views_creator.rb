class RailsDbViews::DbViewsCreator
  attr_reader :views

  def initialize
    @views = {}
  end

  def register_files files
    files.each do |file|
      view_name = File.basename(file, File.extname(file))

      content = File.read(file)
      content_lines = content.split("\n")

      # Reject the commented lines from the file
      sql_content = content_lines.reject{ |x| x.strip =~ /^--/ || x.strip =~ /^#/ }.join("\n")

      file_obj = { path: file, sql_content: sql_content, status: :none, requires: [] }

      # Detect directives in commentary
      directives = content_lines.select{ |x| x.strip =~ /^--/ || x.strip =~ /^#/ }.map(&:strip).map{ |x| 
        x =~ /^--/ ? x[2..-1] : x[1..-1]
      }.select{|x| x =~ /^!/ }

      directives.each do |directive|
        if directive =~ /^!require / #Currently only the require directive exists.
          file_obj[:requires] += directive.split(" ")[1..-1]
        end
      end

      if @views[view_name]
        puts "WARNING: #{view_name} already defined in `#{@views[view_name][:path]}`. Will be ignored and we use `#{file_obj[:path]}`..."
      end

      @views[view_name] = file_obj
    end
  end

  def drop_views
    reset_views_status!
    @views.each{ |name, view|
      drop_view name, view
    }
  end

  def create_views
    reset_views_status!
    @views.each{ |name, view|
      create_view name, view
    }
  end

private
  def reset_views_status!
    @views.each{ |name, view|
      view[:status] = :none
    }
  end


  def drop_view name, view
    return if view[:status] == :loaded

    if view[:status] == :inprogress
      raise "Error: Circular file reference! (view #{name})"
    end

    view[:requires].each do |other_view|
      drop_view other_view, @views[other_view]
    end

    sql = "DROP VIEW #{name}"
    begin
      ActiveRecord::Base.connection.execute(sql)
      puts "DROP VIEW #{name}... OK"
    rescue
      puts "WARNING: DROP VIEW #{name}... ERROR"
    end

    view[:status] = :loaded
  end

  def create_view name, view
    # View already loaded.
    return if view[:status] == :loaded

    if view[:status] == :inprogress
      raise "Error: Circular file reference! (view #{name})"
    end

    view[:status] = :inprogress

    view[:requires].each do |other_view|
      create_view other_view, @views[other_view]
    end

    sql = "CREATE VIEW #{name} AS #{view[:sql_content]}"
    ActiveRecord::Base.connection.execute(sql)
    puts "CREATE VIEW #{name} AS... OK"

    view[:status] = :loaded
  end

end
