def apply_to files, method, klazz
  RailsDbViews::Factory.clear!
  RailsDbViews::Factory.register_files klazz, files
  RailsDbViews::Factory.send(method, klazz)
end

def expand_files paths, extension
  files = []
  paths.each do |path|
    files = files + Dir[File.join(path, extension)].map{|x| File.expand_path(x)}
  end
  return files.sort
end

namespace :db do

  desc "Create all the database views of the current project. Views are usually located in db/views"
  task :create_views => :environment do
    config = Rails.configuration.rails_db_views
    files = expand_files config.views_paths, config.views_extension
    apply_to files, :create, RailsDbViews::View
  end

  desc "Drop all the database views of the current project"
  task :drop_views => :environment do
    config = Rails.configuration.rails_db_views
    files = expand_files config.views_paths, config.views_extension
    apply_to files.reverse, :drop, RailsDbViews::View
  end

  desc "Create or replace all the functions"
  task :create_functions => :environment do
    adapter_type = ActiveRecord::Base.connection.adapter_name.downcase.to_sym
    config = Rails.configuration.rails_db_views

    if adapter_type != :sqlite
      files = expand_files config.functions_paths, config.functions_extension
      apply_to files, :create, RailsDbViews::Function
    else
      if config.functions_paths.length>=1 || File.is_directory?(config.functions_paths.try(:first))
        puts "Notice: db:create_functions will not trigger for sqlite."
      end
    end
  end

  desc "Remove all the functions (to use manually only)"
  task :drop_functions => :environment do
    config = Rails.configuration.rails_db_views
    files = expand_files config.functions_paths, config.functions_extension
    apply_to files.reverse, :drop, RailsDbViews::Function
  end
end

require 'rake/hooks'

Rails.configuration.rails_db_views.migration_tasks.each do |task|
  before(task){ Rake::Task['db:drop_views'].invoke }
  before(task){ Rake::Task['db:create_functions'].invoke }
  after(task){ Rake::Task['db:create_views'].invoke }
end
