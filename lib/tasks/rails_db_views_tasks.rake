namespace :db do

  desc "Generate all the database views of the current project"
  task :create_views => :environment do
    creator = RailsDbViews::DbViewsCreator.new

    views_path, views_ext = Rails.configuration.rails_db_views[:views_path], Rails.configuration.rails_db_views[:views_ext]

    views_path.each do |path|
      creator.register_files Dir[File.join(path, views_ext)].map{|x| File.expand_path(x)}
    end

    creator.create_views
  end

  desc "Drop all the database views of the current project"
  task :drop_views => :environment do
    creator = RailsDbViews::DbViewsCreator.new

    views_path, views_ext = Rails.configuration.rails_db_views[:views_path], Rails.configuration.rails_db_views[:views_ext]

    views_path.each do |path|
      creator.register_files Dir[File.join(path, views_ext)].map{|x| File.expand_path(x)}
    end

    creator.drop_views
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