namespace :db do

  desc "Create all the database views of the current project. Views are usually located in db/views"
  task :create_views => :environment do
    views_path, views_ext = Rails.configuration.rails_db_views[:views_path], Rails.configuration.rails_db_views[:views_ext]

    RailsDbViews::Factory.clear!

    views_path.each do |path|
      RailsDbViews::Factory.register_files RailsDbViews::View, Dir[File.join(path, views_ext)].map{|x| File.expand_path(x)}
    end

    RailsDbViews::Factory.create RailsDbViews::View
  end

  desc "Drop all the database views of the current project"
  task :drop_views => :environment do
    views_path, views_ext = Rails.configuration.rails_db_views[:views_path], Rails.configuration.rails_db_views[:views_ext]

    RailsDbViews::Factory.clear!

    views_path.each do |path|
      RailsDbViews::Factory.register_files RailsDbViews::View, Dir[File.join(path, views_ext)].map{|x| File.expand_path(x)}
    end

    creator.drop RailsDbViews::View
  end
end

require 'rake/hooks'

before "db:migrate" do
  Rake::Task['db:drop_views'].invoke
end
before "db:rollback" do
  Rake::Task['db:drop_views'].invoke
end

after "db:migrate" do
  Rake::Task['db:create_views'].invoke
end
after "db:rollback" do
  Rake::Task['db:create_views'].invoke
end