class Railtie < Rails::Railtie
  railtie_name :rails_db_view

  config.rails_db_view = ActiveSupport::OrderedHash.new

  initializer "rails_db_view.initialize" do |app|
    app.config.rails_db_view[:views_path] = %w( db/views )
    app.config.rails_db_view[:views_ext] = "*.sql"
  end

  rake_tasks do
    load "tasks/rails_db_view_tasks.rake"
  end
end
