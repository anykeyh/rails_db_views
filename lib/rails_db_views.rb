module RailsDbViews
  unless defined?(Rails)
    raise LoadError, "rails_db_views gem is made for Ruby on Rails !"
  end
end

require 'rails_db_views/exceptions'
require 'rails_db_views/railtie'
require 'rails_db_views/database_symbol'
require 'rails_db_views/view'
require 'rails_db_views/function'
require 'rails_db_views/factory'
