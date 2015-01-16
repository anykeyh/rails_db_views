class Railtie < Rails::Railtie
  railtie_name :rails_db_views

  config.rails_db_views = ActiveSupport::OrderedHash.new

  initializer "rails_db_views.initialize" do |app|
    app.config.rails_db_views[:views_path] = %w( db/views )
    app.config.rails_db_views[:views_ext] = "*.sql"
  end

  rake_tasks do
    load "tasks/rails_db_views_tasks.rake"
  end
end
