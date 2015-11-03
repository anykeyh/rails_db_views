require 'rails_db_views/configuration'

class RailsDbViews::Railtie < Rails::Railtie
  railtie_name :rails_db_views

  config.rails_db_views = RailsDbViews::Configuration.new

  initializer "rails_db_views.initialize" do |app|
  end

  rake_tasks do
    load "tasks/rails_db_views_tasks.rake"
  end
end
