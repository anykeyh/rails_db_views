class RailsDbViews::DatabaseSymbol
  class CircularReferenceError < RuntimeError; end
  class SymbolNotFound < RuntimeError; end

  attr_accessor :path, :sql_content, :status, :requires, :marked_as_deleted
  alias :marked_as_deleted? :marked_as_deleted

  module Status
    LOADED      = :loaded
    IN_PROGRESS = :in_progress
    UNLOADED    = :unloaded
  end

  def initialize file_path
    @path = file_path
    @name = File.basename(file_path)

    @status = :none
    @requires = []
    @marked_as_deleted = false

    load_directives
  end

  def mark_as_delete!
    @marked_as_deleted = true
  end

  def loaded?
    status == Status::LOADED
  end

  def in_progress?
    status == Status::IN_PROGRESS
  end

  def unloaded?
    status == Status::UNLOADED
  end

  def create!
    return if marked_as_deleted? || loaded?

    circular_reference_error if in_progress?

    self.status = Status::IN_PROGRESS

    requires.each do |symbol_name|
      symbol = RailsDbViews::DbViewsCreator.get(self.class, symbol_name)
      error_not_found(symbol_name) if symbol.nil?
      symbol.create!
    end

    sql = "CREATE VIEW #{name} AS #{sql_content}"
    ActiveRecord::Base.connection.execute(sql)
    puts "CREATE VIEW #{name} AS... OK"

    self.status = Status::LOADED

    reset_views_status!
  end

  def drop!
    return if loaded?

    circular_reference_error if in_progress?

    self.status = Status::IN_PROGRESS

    requires.each do |symbol_name|
      symbol = RailsDbViews::DbViewsCreator.get(self.class, symbol_name)
      error_not_found(view_name) if symbol.nil?
      symbol.drop!
    end

    begin
      ActiveRecord::Base.connection.execute(to_sql)
      puts "DROP VIEW #{name}... OK"
    rescue
      puts "WARNING: DROP VIEW #{name}... ERROR"
    end

    self.status = Status::LOADED
  end

  # Theses methods should be implemented in children objects.
  def to_sql
    raise NotImplementedError
  end

  def handle_error_on_drop
    raise NotImplementedError
  end

protected
  TWO_DASH_DIRECTIVE_START = /^--[ \t]*!/
  SHARP_CHAR_DIRECTIVE_START = /^#[ \t]*!/
  DIRECTIVE_START = /#{TWO_DASH_DIRECTIVE_START}|#{SHARP_CHAR_DIRECTIVE_START}/

  def circular_reference_error
    raise CircularReferenceError, "Circular file reference! (file: #{path})"
  end

  def not_found_error(symbol_name)
    raise SymbolNotFound, "D'oh! #{self.class.name.capitalize} #{symbol_name} referenced in file #{path} cannot be found..."
  end

  def load_directives
    content_lines = content.split("\n")

    directives = content_lines.map(&:strip).select{ |x| x =~ DIRECTIVE_START }.map{ |x|
        x.gsub(DIRECTIVE_START, "")
    }

    directives.each do |d|
      case d
      when /^require /
        self.requires += d.split(/ +/)[1..-1]
      when /^delete(d?) /
        self.mark_as_delete!
      else
        raise IllegalDirective, "I don't know what to do with `#{d}` (in #{path})"
      end
    end

  end

end