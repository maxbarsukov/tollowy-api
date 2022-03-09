# Mark existing migrations as safe
StrongMigrations.start_after = 2022_02_08_12_40_19 # rubocop:disable Style/NumericLiterals

# Set timeouts for migrations
# If you use PgBouncer in transaction mode, delete these lines and set timeouts on the database user
StrongMigrations.lock_timeout = 10.seconds
StrongMigrations.statement_timeout = 1.hour

# Analyze tables after indexes are added
# Outdated statistics can sometimes hurt performance
StrongMigrations.auto_analyze = true

# Add custom checks
# StrongMigrations.add_check do |method, args|
#   if method == :add_index && args[0].to_s == "users"
#     stop! "No more indexes on the users table"
#   end
# end

StrongMigrations.disable_check(:add_index)
StrongMigrations.disable_check(:remove_column)
StrongMigrations.disable_check(:rename_table)
StrongMigrations.disable_check(:create_table)
StrongMigrations.disable_check(:add_foreign_key)
