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
2. [Available Scripts](#scripts)
3. [Testing](#testing)
4. [Tools](#tools)
5. [Contributing](#contributing)
6. [Code of Conduct](#code-of-conduct)
7. [License](#license)

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

- Install [Ruby](https://www.ruby-lang.org/en/documentation/installation/) *(strictly higher **3.1.2**)*;
- Install [Ruby on Rails](https://guides.rubyonrails.org/getting_started.html) (**7.0.3**);
- Install [PostgreSQL](https://www.postgresql.org/download/) *(tested with **14.3**)*;
- Install [Redis](https://redis.io/download/) *(tested with **7.0.0**)*;
- Install [JDK](https://openjdk.org/) *(tested with **OpenJDK 17**)*;
- Install [Elasticsearch](https://www.elastic.co/downloads/elasticsearch) *(tested with **8.2.0**)*;
- Install [Nginx](https://nginx.org/ru/download.html) *(tested with **1.20.2**)*;

***or***

- Install [Docker](https://www.ruby-lang.org/en/documentation/installation/);
- Install [docker-compose](https://www.ruby-lang.org/en/documentation/installation/);

Clone this repository:

    git clone git@github.com:maxbarsukov/tollowy-api.git

Install dependencies:

    bundle install

Setup git hooks:

    overcommit --install

Setup `CrystalBall` for regression test selection :

    CRYSTALBALL=true DONT_GENERATE_REPORT=true bin/tests

### Building and Running <a name="run"></a>

    foreman start

Need more detailed installation instructions?
[We have them](./docs/install.md).


## Available Scripts <a name="scripts"></a>

#### Database
- `rails db:seed` – seeds database and exports seeded data to `.csv` file by default.
  - Use `rails db:seed export=false` to not generate csv files.
  - Use `rails db:seed force=true` to  seed db even if there is existing data.
- `rails db:seed load=true` – loads data to database from `db/fixtures/*.csv` files.

#### Elasticsearch
- `rake searchkick:reindex:all` – Reindex all models with default `Searchkick` tool;
- `rake searchkick:reindex:custom:all` – Custom models reindex with eager loading;

#### Documentation
- Run `bundle exec yardoc` to generate app documentation to `docs/yard` folder;

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

## Testing <a name="testing"></a>

Run `bundle exec rails spec` to launch the test runner.

Check the quality of code with `buncle exec rubocop`

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


====================================

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions
