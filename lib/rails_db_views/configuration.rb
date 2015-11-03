class RailsDbView::Configuration

  attr_accessor :view_paths, :view_extension
  attr_accessor :function_paths, :function_extension

  def initialize
    @view_paths = %w( db/views )
    @view_extension = "*.sql"

    @function_paths = %w(db/functions)
    @function_extension = "*.sql"
  end

end