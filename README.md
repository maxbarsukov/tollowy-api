<h1 align="center">Welcome to ƒolloʍʎ 🔮👋</h1>
<p align="center">
  <b>Yet Another Followy API</b> built with <em>Rails 7</em>
    <br /><br />
    <img alt="Made with Rails" src="https://img.shields.io/badge/Made%20with-Rails-%23CC0000?logo=ruby&logoColor=white">
    <img alt="Code style: rubocop" src="https://img.shields.io/badge/code%20style-rubocop-AD1401.svg">
    <br />
    <a href="https://maxbarsukov.semaphoreci.com/projects/tollowy-api"><img alt="Semaphore CI" src="https://maxbarsukov.semaphoreci.com/badges/tollowy-api.svg" /></a>
    <a href="https://github.com/maxbarsukov/tollowy-api/actions/workflows/ci.yml"><img src="https://github.com/maxbarsukov/tollowy-api/workflows/CI/badge.svg" alt="CI Build Status" /></a>
    <a href="https://github.com/maxbarsukov/tollowy-api/actions/workflows/docker.yml"><img src="https://github.com/maxbarsukov/tollowy-api/workflows/Docker/badge.svg" alt="Docker Build Status" /></a>
    <br />
    <a href="https://www.codefactor.io/repository/github/maxbarsukov/tollowy-api/overview/master"><img src="https://www.codefactor.io/repository/github/maxbarsukov/tollowy-api/badge/master" alt="CodeFactor" /></a>
    <a href="https://dashboard.guardrails.io/gh/maxbarsukov/repos/117025" target="_blank"><img alt="GuardRails" title="GuardRails" src="https://api.guardrails.io/v2/badges/maxbarsukov/tollowy-api.svg?token=70b5093a890df31a9bafc7c989da2f392e086053ea18441c74db30a008f7e22d&provider=github"/></a>
    <a href="https://dependabot.com" target="_blank"><img alt="Dependabot" title="Dependabot" src="https://img.shields.io/badge/dependabot-enabled-success.svg"/></a>
    <br />
    <a href="https://codeclimate.com/github/maxbarsukov/tollowy-api/maintainability"><img alt="CodeClimate Maintainability" src="https://api.codeclimate.com/v1/badges/8965ffb2726f8b662429/maintainability" /></a>
    <a href="https://codeclimate.com/github/maxbarsukov/tollowy-api/test_coverage"><img alt="CodeClimate Test Coverage" src="https://api.codeclimate.com/v1/badges/8965ffb2726f8b662429/test_coverage" /></a>
</p>


## Table of contents
0. [Technologies](#technologies)
1. [Getting Started](#getting-started)
    1. [Pre-reqs](#pre-reqs)
    2. [Building and Running](#run)
    3. [Tuning](#tuning)
2. [Available Scripts](#scripts)
3. [Testing](#testing)
4. [Linting](#linting)
5. [Tools](#tools)
6. [Other](#other)
7. [Contributing](#contributing)
8. [Code of Conduct](#code-of-conduct)
9. [License](#license)

## Technologies <a name="technologies"></a>

[![Made with: Ruby](https://img.shields.io/badge/Ruby-fbefeb?style=for-the-badge&logo=ruby&logoColor=AD1401)](https://www.ruby-lang.org/)
[![Made with: Rails](https://img.shields.io/badge/Rails-CC0000?style=for-the-badge&logo=rubyonrails&logoColor=white)](https://rubyonrails.org/)
[![Made with: RSpec](https://img.shields.io/badge/RSpec-81d2ed?style=for-the-badge&logo=rubygems&logoColor=ef4e6f)](https://rubyonrails.org/)

[![Made with: Redis](https://img.shields.io/badge/redis-white?style=for-the-badge&logo=redis&logoColor=D82C20)](https://redis.io/)
[![Made with: PostgreSQL](https://img.shields.io/badge/PostgreSQL-2F6792?style=for-the-badge&logo=PostgreSQL&logoColor=white)](https://www.postgresql.org/)
[![Made with: Elasticsearch](https://img.shields.io/badge/Elasticsearch-343741?style=for-the-badge&logo=elasticsearch&logoColor=00BFB3&color=FEC514&labelColor=343741)](https://www.elastic.co/)

[![Made with: Swagger](https://img.shields.io/badge/Swagger-85EA2D?style=for-the-badge&logo=swagger&logoColor=black)](https://swagger.io/)
[![Made with: Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)](https://www.docker.com/)
[![Made with: Nginx](https://img.shields.io/badge/nginx-009900?style=for-the-badge&logo=nginx&logoColor=white)](https://nginx.org/)


## Getting Started <a name="getting-started"></a>

### Pre-reqs <a name="pre-reqs"></a>

Make sure you have [`git`](https://git-scm.com/) installed.

To build and run this app locally you will need a few things:

- Use [Unix-like OS](https://www.quora.com/Why-do-people-hate-Windows);
- Install [ImageMagick](https://imagemagick.org/index.php) *(tested with **7.1.0-44**)*;
- Check you have [Cron](https://help.ubuntu.ru/wiki/cron) installed *(tested with **cronie 1.6.1**)*;
- Install [Ruby](https://www.ruby-lang.org/en/documentation/installation/) *(strictly higher **3.1.2**)*;
- Install [Ruby on Rails](https://guides.rubyonrails.org/getting_started.html) (**7.0.3**);
- Install [PostgreSQL](https://www.postgresql.org/download/) *(tested with **14.3**)*;
- Install [Redis](https://redis.io/download/) *(tested with **7.0.0**)*;
- Install [JDK](https://openjdk.org/) *(tested with **OpenJDK 17**)*;
- Install [Elasticsearch](https://www.elastic.co/downloads/elasticsearch) *(tested with **8.2.0**)*;
- Check you have [cgroups](https://en.wikipedia.org/wiki/Cgroups) V2 with `memory` controller *(otherwise there will be ElasticSearch error)*;
- Install [Nginx](https://nginx.org/ru/download.html) *(tested with **1.20.2**)*;

***or***

- Install [Docker](https://www.ruby-lang.org/en/documentation/installation/);
- Install [docker-compose](https://www.ruby-lang.org/en/documentation/installation/);

Clone this repository:

    git clone git@github.com:maxbarsukov/tollowy-api.git

Install dependencies:

    bundle install


#### Overcommit

Setup git hooks:

    overcommit --install


#### CrystalBall

Setup `CrystalBall` for regression test selection :

    CRYSTALBALL=true DONT_GENERATE_REPORT=true bin/tests


#### PgHero

To setup `PgHero` you should enable query stats.
Add the following to your `postgresql.conf`:

    shared_preload_libraries = 'pg_stat_statements'
    pg_stat_statements.track = all
    pg_stat_statements.max = 10000
    track_activity_query_size = 2048

Then restart PostgreSQL. As a superuser from the `psql` console, run:

    CREATE extension pg_stat_statements;
    SELECT pg_stat_statements_reset();

For security, Postgres doesn’t allow you to see queries from other users without being a superuser. However, you likely don’t want to run `PgHero` as a superuser. You can use `SECURITY DEFINER` to give non-superusers access to superuser functions.

With a superuser, run:

    $ psql -U postgres -d tollowy_production -a -f bin/pghero-permissions.sql -v pghero_password="'pghero_user_password'" -v database_name=tollowy_development

#### Whenever

To use `whenever` gem you should have `cron` installed.
Run `whenever --update-crontab` to update your crontab.
Use `--set 'environment=production` argument to set environment.

Need more detailed installation instructions?
[We have them](./docs/install.md).

### Building and Running <a name="run"></a>

#### Locally

##### Development:

1) Check you have installed and configured `PostgreSQL`;
2) Change `DATABASE_HOST` and other database data in `.env` file;
3) Run `bundle exec rails db:create` to create database;
4) Run `bundle exec rails db:migrate` to run migrations;
5) **Optional**: Run `bundle exec rails db:seed` to seed database;
6) Check you have installed and configured `Redis` (`ping-pong` works);
7) Check you can start `Sidekiq`;
8) Check you have installed and configured `Elasticsearch` (`curl localhost:9200` *or your own `Elastic` URL* works);
9) Setup `Elasticsearch` username & password and changr `.env` file if needed;
10) Run `bundle exec rails searchkick:reindex:custom:all` to reindex your models;
11) Configure and start `Nginx` if needed;
12) Generate `crontab` with `bundle exec whenever --update-crontab`;

Finally, run `foreman start` and check your `http://localhost:3000` (or `:80` if you use `Nginx`)

##### Production:

1) Repeat 1-12 steps from development guide.
2) Configure your `.env` file and run `bin/setup-production`;
3) Execute `bin/docker-init.sql` and `bin/pghero-permissions.sql` in `psql` console on your production database;

Finally, run `foreman start -f Procfile` to start server in production mode;

### Docker

- Run `bin/docker-setup` to setup your `.env.docker` file anf build containers.
- Use `bin/docker-dev-server` to run server in dev mode with `mailcatcher`.
- Use `bin/docker-prod-server` to run server in production mode.

### Tuning <a name="tuning"></a>

Some `ENV` settings you can use at self-hosted `Followy API`:

#### Rack::Attack
- `FULL_IP_BAN` *(`false` is default)*:
  - **Description**: Ban __ANY__ requests for all IPs that are marked as `blocked`
  - **Usage**: `FULL_IP_BAN=true` at `.env` file or on server start

- `DISABLE_RACK_ATTACK` *(`false` is default)*:
  - **Description**: Disable `Rack::Attack` in production
  - **Usage**: `DISABLE_RACK_ATTACK=true` at `.env` file or on server start

#### Mailing
- `MAIL_USERNAME`: Your mail service username;
- `MAIL_PASSWORD`: Your mail service password;
- `MAIL_ADDRESS`: Your mail service address;
- `MAIL_PORT`: Your mail service port;
- `MAIL_DOMAIN`: Your mail service domain;
- `MAILER_SENDER_ADDRESS`: Your mail sender address (e.g `noreply@followy.ru`);
- `SMTP_OPENSSL_VERIFY_MODE`: Enable/Disable mailer OpenSSL verify mode;

#### Other

- `CONFIRMATION_TOKEN_LENGTH` *(`40` is default)*:
  - **Description**: Set length of generated confirmation token;
  - **Usage**: `CONFIRMATION_TOKEN_LENGTH=N` at `.env` file or on server start

- `RAILS_LOG_TO_STDOUT` *(`false` is default)*:
  - **Description**: Enables logging to STDOUT in production;
  - **Usage**: `RAILS_LOG_TO_STDOUT=true` on server start

## Available Scripts <a name="scripts"></a>

#### Database
- `rails db:seed` – seeds database and exports seeded data to `.csv` file by default.
  - Use `rails db:seed export=false` to not generate csv files.
  - Use `rails db:seed force=true` to  seed db even if there is existing data.
- `rails db:seed load=true` – loads data to database from `db/fixtures/*.csv` files.
- `rails pghero:analyze` – Run `PgHero` database analyzer.
- `rails pghero:rails pghero:autoindex` – Run `PgHero` auto-indexer.
- `rails pghero:capture_query_stats` – Run `PgHero` capture query stats.
- `rails pghero:capture_space_stats` – Run `PgHero` capture space stats.

#### Elasticsearch
- `rake searchkick:reindex:all` – Reindex all models with default `Searchkick` tool;
- `rake searchkick:reindex:custom:all` – Custom models reindex with eager loading;

#### Documentation
- Run `bundle exec yardoc` to generate app documentation to `docs/yard` folder;
- Run `bundle exec rails erd` to generate domain model diagram;

#### Sidekiq
- `bin/clear-sidekiq` to flush existing **Sidekiq** data.

#### Swagger
- `bin/rswag` to generate `swagger.json` file.

#### Generators
- `swagger_schema`:
  - run `rails g swagger_schema -h` to see help message;
  - Examples:
    - `rails g swagger_schema comments/comment --type model` – Create model schema;
    - `rails g swagger_schema comments/destroy --type response` – Create response schema;
    - `rails g swagger_schema comments/create --type parameter` – Create parameter schema;
- Annotations:
  - `rails annotate_models` to annotate models;
  - `rails annotate_routes` to annotate routes;

#### Other
- `rails log:clear` - Truncates all/specified *.log files in log/ to zero bytes
- `rails middleware` - Prints out your Rack middleware stack
- `rails secret` - Generate a cryptographically secure secret key
- `rails stats` - Report code statistics (KLOCs, etc) from the application or engine
- `rails tmp:clear` - Clear cache, socket and screenshot files from tmp/
- `rails tmp:create` - Creates tmp directories for cache, sockets, and pids
- `rails zeitwerk:check` - Checks project structure for Zeitwerk compatibility

## Testing <a name="testing"></a>

### Locally

Run `bin/tests` or `bundle exec rails spec` to launch the test runner.

### Docker

Run `bin/docke-setup` and `bin/docker-tests` to launch tests runner in Docker;


## Linting <a name="linting"></a>

### Locally

1) `bin/rubocop --parallel` to check the quality of code with [rubocop](https://github.com/rubocop/rubocop);
2) `bin/brakeman --quiet --skip-libs --exit-on-warn --no-pager` to run [brakeman](https://github.com/presidentbeef/brakeman);
3) `bin/bundle-audit update` and `bin/bundle-audit` to run [bundler-audit](https://github.com/rubysec/bundler-audit);
4) `bin/bundle exec rails_best_practices . --spec -c config/rails_best_practices.yml` to run [rails_best_practices](https://github.com/flyerhzm/rails_best_practices);
5) `bin/bundle exec rake active_record_doctor` to run [active_record_doctor](https://github.com/gregnavis/active_record_doctor);

or run it together with `bin/quality`

### Docker

Run `bin/docke-setup` and `bin/docker-quality` to launch quality checkers in Docker;


## Other <a name="other"></a>

#### Architecture

`Followy API` is an ordinary Rails monolithic MVC application.
- Use [interactors](https://mkdev.me/posts/a-couple-of-words-about-interactors-in-rails) to take the logic out of the controller  
- Use [payloads](https://github.com/maxbarsukov/tollowy-api/tree/master/app/payloads) to build a response using serialized data from `serializers` and `interactor` data;
- Use [decorators](https://github.com/drapergem/draper) to use an object-oriented layer of presentation logic;

#### Admin & Dev pages

- `/admin/sign_in` page and sign in as Admin or Developer;
- `/admin` page to use ActiveAdmin dashboard (role ≥ admin);
- `/pghero` page to see `PgHero` dashboard (role = developer);
- `/sidekiq` page to see `Sidekiq Web` dashboard (role = developer);

#### Localization

All localization files are in the `config/locales` folder with `ru.yml` and `en.yml` files in subfolders;

Default locale is `en`, available locales - `en` and `ru`.

You can change locale with `?locale=ru` parameter in `API` request or Admin dashboard URL

To add your own locale, create `yourlang.yml` in `/locale` folder subfolders and update `I18n` config at `config/application.rb` file (add new available locale and configure fallbacks).

#### Rack-mini-profiler

Use URL parameters to enable/disable `rack-mini-profiler`:
- `?pp=disable` to disable;
- `?pp=enable` to enable;
- `?pp=help` to see help message;

#### Bullet

[Bullet](https://github.com/flyerhzm/bullet) is a Rails gem that helps to detect `N+1` queries and unused eager loading;

- Logs are located at `log/bullet.log`
- You can find configuration in `config/environment/*` config files;

#### CORS

Cross-Origin Resource Sharing (CORS) configuration placed at `config/initializers/cors.rb`;

#### Mail previews

You can preview your mails at `/rails/mailers/<mailer_name>`;

For example, `AuthMailer#password_recovery` preview in HTML format with `ru` locale you can find at `/rails/mailers/auth_mailer/password_recovery.html?locale=ru`

#### Monkey-patching

Monkey-patched gems located at `config/monkey_patches/*.rb`.

Please, use [refinements](https://docs.ruby-lang.org/en/2.4.0/syntax/refinements_rdoc.html) instead of monkey-patching if ypu can;

#### Cron

- Logs are located at `log/cron_log.log`
- Update `crontab` with `bundle exec whenever --update-crontab`;

#### Profiling

- Use [ruby-prof](https://github.com/ruby-prof/ruby-prof) to profile application.
- Use `ProfilingTool` class to profile requests;
- You can use `qcachegrind` to visualise profiling information
- You can use `tools/benchmark/populate_db_for_posts_votes_bench.rb` to populate database with many users, posts and votes; 

## Tools <a name="tools"></a>

<table>
  <tr>
    <td align="center">
      <b><a href="https://app.codacy.com/gh/maxbarsukov/tollowy-api/dashboard">Codacy</a></b>
    </td>
    <td align="center">
      <a href="https://www.codacy.com/gh/maxbarsukov/tollowy-api/dashboard?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=maxbarsukov/tollowy-api&amp;utm_campaign=Badge_Grade">
        <img src="https://app.codacy.com/project/badge/Grade/86f720bf9079426ebd90be6cbab2d5ab" alt="Codacy Badge"/>
      </a>
    </td>
  </tr>
  <tr>
    <td align="center">
      <b><a href="https://app.codecov.io/gh/maxbarsukov/tollowy-api">Codecov</a></b>
    </td>
    <td align="center">
      <a href="https://codecov.io/gh/maxbarsukov/tollowy-api">
        <img src="https://codecov.io/gh/maxbarsukov/tollowy-api/branch/master/graph/badge.svg?token=57aRuUgwDi" alt="codecov"/>
      </a>
    </td>
  </tr>
  <tr>
    <td align="center">
      <b><a href="https://coveralls.io/github/maxbarsukov/tollowy-api">Coveralls</a></b>
    </td>
    <td align="center">
      <a href="https://coveralls.io/github/maxbarsukov/tollowy-api?branch=master">
        <img src="https://coveralls.io/repos/github/maxbarsukov/tollowy-api/badge.svg?branch=master" alt="Coverage Status" />
      </a>
    </td>
  </tr>
  <tr>
    <td align="center">
      <b><a href="https://codeclimate.com/github/maxbarsukov/tollowy-api">CodeClimate</a></b>
    </td>
    <td align="center">
      <a href="https://codeclimate.com/github/maxbarsukov/tollowy-api/maintainability">
        <img alt="CodeClimate Maintainability" src="https://api.codeclimate.com/v1/badges/8965ffb2726f8b662429/maintainability" />
      </a>
      <br />
      <a href="https://codeclimate.com/github/maxbarsukov/tollowy-api/test_coverage">
        <img alt="CodeClimate Test Coverage" src="https://api.codeclimate.com/v1/badges/8965ffb2726f8b662429/test_coverage" />
      </a>
    </td>
  </tr>
  <tr>
    <td align="center">
      <b><a href="https://www.codefactor.io/repository/github/maxbarsukov/tollowy-api">Codefactor</a></b>
    </td>
    <td align="center">
      <a href="https://www.codefactor.io/repository/github/maxbarsukov/tollowy-api/overview/master">
        <img src="https://www.codefactor.io/repository/github/maxbarsukov/tollowy-api/badge/master" alt="CodeFactor" />
      </a>
    </td>
  </tr>
  <tr>
    <td align="center">
      <b><a href="https://deepsource.io/gh/maxbarsukov/tollowy-api">DeepSource</a></b>
    </td>
    <td align="center">
      <a href="https://deepsource.io/gh/maxbarsukov/tollowy-api/?ref=repository-badge" target="_blank">
        <img alt="DeepSource" title="DeepSource" src="https://deepsource.io/gh/maxbarsukov/tollowy-api.svg/?label=active+issues&show_trend=true&token=H_V7h7eDlbsuMc_pOQL2Sr92"/>
      </a>
      <br />
      <a href="https://deepsource.io/gh/maxbarsukov/tollowy-api/?ref=repository-badge" target="_blank">
        <img alt="DeepSource" title="DeepSource" src="https://deepsource.io/gh/maxbarsukov/tollowy-api.svg/?label=resolved+issues&token=H_V7h7eDlbsuMc_pOQL2Sr92"/>
      </a>
    </td>
  </tr>
<tr>
    <td align="center">
      <b><a href="https://depfu.com/repos/github/maxbarsukov/tollowy-api">Depfu</a></b>
    </td>
    <td align="center">
      <a href="https://depfu.com/repos/github/maxbarsukov/tollowy-api" target="_blank">
        <img alt="Depfu" title="Depfu" src="https://badges.depfu.com/badges/f6285e1e85a61ccd6ef54f65dfb9411f/status.svg"/>
      </a>
      <br />
      <a href="https://depfu.com/github/maxbarsukov/tollowy-api?project_id=34860" target="_blank">
        <img alt="Depfu" title="Depfu" src="https://badges.depfu.com/badges/f6285e1e85a61ccd6ef54f65dfb9411f/count.svg"/>
      </a>
    </td>
  </tr>
</table>


## Contributing <a name="contributing"></a>

Bug reports and pull requests are welcome on GitHub at https://github.com/maxbarsukov/tollowy-api.
This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/maxbarsukov/toylang/blob/master/CODE_OF_CONDUCT.md).


## Code of Conduct <a name="code-of-conduct"></a>

Everyone interacting in the **Tollowy** project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/maxbarsukov/tollowy-api/blob/master/CODE_OF_CONDUCT.md).


## License <a name="license"></a>

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
*Copyright 2022 Tollowy*
