namespace :db do
  desc 'Kills all Postgres connections'
  task kill_postgres_connections: :environment do
    db_name = "#{File.basename(Rails.root)}_#{Rails.env}"
    sh = <<~SHELL
      ps xa \
        | grep postgres: \
        | grep #{db_name} \
        | grep -v grep \
        | awk '{print $1}' \
        | sudo xargs kill
    SHELL
    puts `#{sh}`
  end
end
