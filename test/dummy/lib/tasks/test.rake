task :test do
  begin
    Rake::Task["db:drop"].invoke
  rescue
    # Case the database is not created, we ignore this error
  end
  # But if the database can't be created, we don't ignore.
  Rake::Task["db:create"].invoke
  Rake::Task["db:migrate"].invoke

end
