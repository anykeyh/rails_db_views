module RailsDbViews
  unless defined?(Rails)
    raise "This gem is made for Ruby on Rails!"
  end
end

require 'rails_db_views/railtie'
require 'rails_db_views/database_symbol'
require 'rails_db_views/view'
require 'rails_db_views/function'
require 'rails_db_views/factory'
