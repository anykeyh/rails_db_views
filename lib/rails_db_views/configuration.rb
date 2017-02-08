class RailsDbViews::Configuration
  attr_accessor :views_paths, :views_extension
  attr_accessor :functions_paths, :functions_extension
  attr_accessor :migration_tasks

  def initialize
    @views_paths = %w(db/views)
    @views_extension = "*.sql"

    @functions_paths = %w(db/functions)
    @functions_extension = "*.sql"

    @migration_tasks = %w(db:migrate db:rollback)
  end

  def [] *args
    raise "rails_db_view has changed! Please use the methods views_paths/views_extension instead of hash notation"
  end
end
