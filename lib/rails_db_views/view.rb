class RailsDbViews::View < RailsDbViews::DatabaseSymbol
  def create_sql
    puts "CREATE VIEW #{name}..."
    "CREATE VIEW #{name} AS #{uncommented_sql_content}"
  end

  def drop_sql
    puts "DROP VIEW #{name}..."
    "DROP VIEW #{name}"
  end

  def handle_error_on_drop
    puts "WARNING: DROP VIEW #{name}... ERROR"
  end
end