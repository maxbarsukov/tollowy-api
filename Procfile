web: bundle exec whenever --set 'environment=production' --update-crontab tollowy_production && bundle exec rails server -p $PORT -e production -b 0.0.0.0
worker: bundle exec sidekiq -e production
