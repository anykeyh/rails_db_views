class RailsDbViews::Function < RailsDbViews::DatabaseSymbol
  def create_sql
    puts "CREATE OR REPLACE FUNCTION #{name}..."
    "CREATE OR REPLACE FUNCTION #{name} #{sql_content}"
  end

  def drop_sql
    puts "DROP FUNCTION #{name}..."
    "DROP FUNCTION #{name}"
  end

  def handle_error_on_drop
    puts "WARNING: DROP FUNCTION #{name}... ERROR"
  end
end