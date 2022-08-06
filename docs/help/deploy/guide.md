1) `git clone https://github.com/maxbarsukov/tollowy-api tollowy`;
2) `cd tollowy`;
3) `bundle install`;
4) `sudo -u postgres createuser -s tollowy`;
5) ```shell
   sudo -u postgres psql
   # set your <user_password>
   \password tollowy
   \q
   ```
6) ```shell
   # in .env file
   DATABASE_USER=tollowy
   DATABASE_PASSWORD =<user_password>
   RAILS_SERVE_STATIC_FILES=true
   RAILS_MAX_THREADS=10
   ```
7) `RAILS_ENV=production bundle exec rails db:create`;
8) `RAILS_ENV=production bundle exec db:migrate`;
9) `RAILS_ENV=production bundle exec assets:precompile`;
10) `grep -c processor /proc/cpuinfo` - check your CPU cores count (`<CPU_CORES>`);
11) Set `WEB_CONCURRENCY=<CPU_CORES>` in `.env` file;
12) `mv config/delpoy/puma.rb config/puma.rb`;
13) `mkdir -p shared/pids shared/sockets shared/log`;
14) ```shell
     cd ~
     wget https://raw.githubusercontent.com/puma/puma/master/tools/jungle/upstart/puma-manager.conf
     wget https://raw.githubusercontent.com/puma/puma/master/tools/jungle/upstart/puma.conf
     ```
15) ```shell
    vi puma.conf
    # if your deployment user is called "deploy", the lines should look like this
    setuid deploy
    setgid deploy
    ```
16) `sudo cp puma.conf puma-manager.conf /etc/init`
17) ```shell
    sudo vi /etc/puma.conf # =>
    /home/deploy/tollowy
    ```
18) `sudo start puma-manager` or `sudo start puma app=/home/deploy/tollowy`;
19) To stop / restart tun `sudo stop puma-manager` and `sudo restart puma-manager`;
20) Check NGINX installed;
21) `ulimit -n 200000`;
22) `mv config/delpoy/nginx.conf /etc/nginx/sites-available/default`;
23) `sudo vi /etc/nginx/sites-available/default`;
24) `RAILS_ENV=production rails server --binding=<server_public_IP> --early-hints --daemon`;
25) Start NGINX;
