def apply_to paths, extension, method, klazz
  RailsDbViews::Factory.clear!

  paths.each do |path|
    RailsDbViews::Factory.register_files klazz,
      Dir[File.join(path, extension)].map{|x| File.expand_path(x)}.sort
  end

  RailsDbViews::Factory.send(method, klazz)
end

namespace :db do

  desc "Create all the database views of the current project. Views are usually located in db/views"
  task :create_views => :environment do
    config = Rails.configuration.rails_db_views
    apply_to config.views_paths, config.views_extension, :create, RailsDbViews::View
  end

  desc "Drop all the database views of the current project"
  task :drop_views => :environment do
    config = Rails.configuration.rails_db_views
    apply_to config.views_paths, config.views_extension, :drop, RailsDbViews::View
  end

  desc "Create or replace all the functions"
  task :create_functions => :environment do
    adapter_type = ActiveRecord::Base.connection.adapter_name.downcase.to_sym
    config = Rails.configuration.rails_db_views

    if adapter_type != :sqlite
      apply_to config.functions_paths, config.functions_extension, :create, RailsDbViews::Function
    else
      if config.functions_paths.length>=1 || File.is_directory?(config.functions_paths.try(:first))
        puts "Notice: db:create_functions will not trigger for sqlite."
      end
    end
  end

  desc "Remove all the functions (to use manually only)"
  task :drop_functions => :environment do
    config = Rails.configuration.rails_db_views
    apply_to config.functions_paths, config.functions_extension, :drop, RailsDbViews::Function
  end
end

require 'rake/hooks'

Rails.configuration.rails_db_views.migration_tasks.each do |task|
  before(task){ Rake::Task['db:drop_views'].invoke }
  before(task){ Rake::Task['db:create_functions'].invoke }
  after(task){ Rake::Task['db:create_views'].invoke }
end
