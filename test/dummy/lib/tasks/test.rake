# I've no idea of what I'm doing... haha.
# No, really, I don't know what's the best way to test
# this gem since it's launched during rake process and not during
# application time.
task :test do
  begin
    Rake::Task["db:drop"].invoke
  rescue
    # Case the database is not created, we ignore this error
  end
  # But if the database can't be created, we don't ignore.
  Rake::Task["db:create"].invoke
  Rake::Task["db:migrate"].invoke

  # Launch RoR
  Rake::Task["environment"].invoke

  #Create some models
  
end
