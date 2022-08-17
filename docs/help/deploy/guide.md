## First deploy pre-reqs:

Check you have `rvm`, `ruby`, `jvm`, `postgresql`, `elasticsearch` and `nginx` installed

### Install packages

1) ```shell
   sudo apt-get install apt-transport-https
                        libc-dev libffi-dev libxml2-dev
                        imagemagick libgcrypt-dev make netcat-openbsd 
                        tzdata file libmagic-dev 
   ```

### Install gems
1) Install global gems: `gem install --no-document bundler foreman yard rails mailcatcher`
2) If `mailcatcher` build fails, run `gem install thin -v '1.5.0' -- --with-cflags="-Wno-error=implicit-function-declaration"`
3) `bundle install -j4 --retry 3`

### Install redis
1) `sudo apt-get install redis-server`
2) `sudo systemctl enable --now redis-server.service`

### Make cron backup
1) `sudo cp /etc/crontab /etc/crontab.bak`

### Setup Postgres:

1) Add to `postgresql.conf`:
   ```shell
   shared_preload_libraries = 'pg_stat_statements'
   pg_stat_statements.track = all
   pg_stat_statements.max = 10000
   track_activity_query_size = 2048
   ```
2) ```shell
   sudo -u postgres psql
   CREATE extension pg_stat_statements;
   SELECT pg_stat_statements_reset();
   CREATE ROLE tollowy WITH SUPERUSER CREATEROLE CREATEDB REPLICATION LOGIN PASSWORD '<your-postgres-password>';
   \q
   ```
3) If needed, update peer method to `md5` at `pg_hba.conf`
4) ```shell
   # in .env file
   DATABASE_USER=tollowy
   DATABASE_PASSWORD =<your-postgres-password>
   ```
5) `RAILS_ENV=production bundle exec rails db:create`;
6) `RAILS_ENV=production bundle exec rails db:migrate`;

### Setup Elasticsearch:

1) Add to `elasticsearch.yml`:
   ```shell
   http.cors.allow-origin: "/.*/"
   http.cors.enabled: true

   network.bind_host: 0.0.0.0
   network.host: localhost
   discovery.type: single-node
   ```
2) Update `jvm.options` in `/etc/elasticsearch/jvm.options.d/jvm.options`:
   ```shell
   -Xms2g
   -Xmx2g
   ```

### Update ENV
1) In `.env` file:
   ```shell
   RAILS_SERVE_STATIC_FILES=true
   RAILS_MAX_THREADS=10
   ```
2) `grep -c processor /proc/cpuinfo` - check your CPU cores count (`<CPU_CORES>`);
3) Set `WEB_CONCURRENCY=<CPU_CORES>` in `.env` file;

### Other
1) `ulimit -n 200000`;

## Deploy:

```shell
# /home/deploy
# stop previous foreman run
cd apps
mv tollowy tollowy-backup-$(date +%Y%m%d-%H%M%S)
git clone https://github.com/maxbarsukov/tollowy-api tollowy
cd tollowy

sudo systemctl stop nginx.service

mv config/deploy/puma.rb config/puma.rb
mv config/deploy/Procfile.delploy Procfile
mv config/delpoy/nginx.conf /etc/nginx/nginx.conf
mv config/delpoy/api.followy.ru.conf /etc/nginx/sites-enabled/api.followy.ru

RAILS_ENV=production bundle exec rails assets:precompile
RAILS_ENV=production bundle exec rails db:migrate

RAILS_ENV=production foreman start -f Procfile
sudo systemctl start nginx.service
```
