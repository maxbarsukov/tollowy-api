# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

set :output, 'log/cron_log.log'

# Reindex Tag records every 10 minutes
every 10.minutes do
  rake 'searchkick:reindex CLASS=Tag'
end

every 5.minutes do
  rake 'pghero:capture_query_stats'
end

every 1.day do
  rake 'pghero:capture_space_stats'
end

# Learn more: http://github.com/javan/whenever
