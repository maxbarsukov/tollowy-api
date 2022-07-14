source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby File.read('.ruby-version').strip

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem 'rails', '~> 7.0.2', '>= 7.0.2.4'

# Use postgresql as the database for Active Record
gem 'pg', '~> 1.1'

# Use the Puma web server [https://github.com/puma/puma]
gem 'puma', '>= 5.6.4'

# A pure ruby implementation of JWT standard
gem 'jwt', '~> 2.3'

# Object oriented authorization for Rails applications
gem 'pundit', '~> 2.1', '>= 2.1.1'

# Role management library with resource scoping
gem 'rolify', '~> 6.0'

# # Allow any model to follow any other model
gem 'acts_as_follower', github: 'forem/acts_as_follower', branch: 'master'

# Rails gem to allowing records to be votable
gem 'acts_as_votable', '~> 0.13.2'

# A tagging plugin for Rails applications that allows for custom tagging along dynamic contexts
gem 'acts-as-taggable-on', '~> 9.0', '>= 9.0.1'

# A library for creating slugs
gem 'babosa', '~> 2.0'

# Ruby integrations for Elasticsearch (client, API, etc.)
gem 'elasticsearch', '~> 8.3'

# Intelligent search made easy with Rails and Elasticsearch
gem 'searchkick', '~> 5.0', '>= 5.0.4'

# Turbo-charged counter caches for your Rails app
gem 'counter_culture', '~> 3.2', '>= 3.2.1'

# The fastest JSON parser and object serializer.
gem 'oj', '~> 3.13', '>= 3.13.11'

# Fast, simple and easy to use JSON:API serialization library
gem 'jsonapi-serializer', '~> 2.2'

# Simple, efficient background processing for Ruby
gem 'sidekiq', '~> 6.4', '>= 6.4.2'

# Catch unsafe migrations in development
gem 'strong_migrations', '~> 1.0'

# An easy-to-use wrapper for Net::HTTP, Net::HTTPS and Net::FTP.
gem 'open-uri', '~> 0.2.0'

# Enumerated attributes with I18n support
gem 'enumerize', '~> 2.3', '>= 2.3.1'

# Provides a common interface for performing complex interactions
gem 'interactor', '~> 3.1', '>= 3.1.2'
gem 'interactor-rails', '~> 2.2', '>= 2.2.1'

# With the query builder we can easily define logic for query filters
gem 'jsonapi-query_builder', '~> 0.3.0'

# Autoload dotenv in Rails.
gem 'dotenv-rails', '~> 2.7', '>= 2.7.6'

# Draper adds an object-oriented layer of presentation logic to your Rails apps.
gem 'draper', '~> 4.0', '>= 4.0.2'

# RSwag
gem 'rswag-api', '~> 2.5', '>= 2.5.1'
gem 'rswag-ui', '~> 2.5', '>= 2.5.1'

# A library for bulk inserting data using ActiveRecord.
gem 'activerecord-import', '~> 1.3'

# Files attachments
gem 'carrierwave', '~> 2.2', '>= 2.2.2'
# Protect your carrierwave from image bombs
gem "carrierwave-bombshelter", "~> 0.2"
gem 'mini_magick', '~> 4.11'

# Ruby FFI bindings to libmagic
gem 'magic', '~> 0.2.9'

# Use Redis adapter to run Action Cable in production
gem 'redis', '~> 4.0'

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
gem 'kredis'

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
gem 'bcrypt', '~> 3.1.7'

# Agnostic pagination in plain ruby
gem 'pagy', '~> 5.10', '>= 5.10.1'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem 'sprockets-rails'

# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem 'importmap-rails'

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem 'turbo-rails'

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem 'stimulus-rails'

# Use Sass to process CSS
gem 'sassc-rails'

# The administration framework for Ruby on Rails [https://github.com/activeadmin/activeadmin]
gem 'activeadmin', '~> 2.11', '>= 2.11.1'

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem 'rack-cors'

# A rack middleware for throttling and blocking abusive requests
gem 'rack-attack', '~> 6.6'

group :development, :test do
  # Help to kill N+1 queries and unused eager loading
  gem 'bullet', '~> 7.0', '>= 7.0.1'
  # Provides patch-level verification for Bundled apps.
  gem 'bundler-audit', '~> 0.9.0'
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'debug', platforms: %i[mri mingw x64_mingw]
  # Provides a framework and DSL for defining and using factories
  gem 'factory_bot', '~> 6.2'
  gem 'factory_bot_rails', '~> 6.2'
  # A library for generating fake data
  gem 'faker', '~> 2.19'
  # Pry is a runtime developer console
  gem 'pry', '~> 0.14.1'
  # Extracting `assigns` and `assert_template` from ActionDispatch.
  gem 'rails-controller-testing', '~> 1.0', '>= 1.0.5'
  # Provides a pure Ruby implementation of the GNU readline C library
  gem 'rb-readline', '~> 0.5.5'
  # Set of matchers and helpers for testing API
  gem 'rspec-json_expectations', '~> 2.2'
  # Testing framework
  gem 'rspec-rails', '~> 5.1'
  # RSwag
  gem 'rswag-specs', '~> 2.5', '>= 2.5.1'
end

group :development do
  # Auto annotations
  gem 'annotate', require: false
  # Better error page for Rack apps
  gem 'better_errors'
  gem 'binding_of_caller'
  # Annotate your Rails controllers with route info
  gem 'chusaku', '~> 0.6.1', require: false
  # Provides simple way to integrate regression test selection approach
  gem 'crystalball', '~> 0.7.0'
  # Code metric tool for rails codes
  gem 'rails_best_practices', '~> 1.22', '>= 1.22.1', require: false
  # Helps to keep the database in a good shape
  gem 'active_record_doctor', '~> 1.9'
  # Static analysis security vulnerability scanner for RoR applications
  gem 'brakeman', require: false
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'listen', '~> 3.7', '>= 3.7.1'
  # Utility to install, configure, and extend Git hooks
  gem 'overcommit', '~> 0.58.0', require: false
  gem 'rack-mini-profiler', '~> 2.3', '>= 2.3.3'
  # Generate Entity-Relationship Diagrams for Rails applications
  gem 'rails-erd', '~> 1.6', '>= 1.6.1'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0', '>= 2.0.1'

  # Rails Console on the Browser
  gem 'web-console', '~> 4.2'

  # A Ruby parser written in pure Ruby.
  gem 'parser', '~> 3.1', '>= 3.1.2.0'

  # Code style checking and code formatting tool
  gem 'rubocop', require: false
  gem 'rubocop-faker', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rake', require: false
  gem 'rubocop-rspec', require: false

  # YARD is a Ruby Documentation tool
  gem 'yard', require: false
end

group :test do
  # Strategies for cleaning databases
  gem 'database_cleaner', '~> 2.0', '>= 2.0.1'
  # Easily test email in RSpec, Cucumber, and MiniTest
  gem 'email_spec', '~> 2.2'
  # Code coverage for Ruby with a powerful configuration library
  gem 'simplecov', '~> 0.21'
  gem 'simplecov-lcov', '~> 0.8.0'
  # Test coverage
  gem 'coveralls_reborn', '~> 0.23.1', require: false
  # Provides RSpec- and Minitest-compatible one-liners to test common Rails functionality
  gem 'shoulda-matchers', '~> 5.1'
  # Test Rails generators with RSpec
  gem 'generator_spec', '~> 0.9.4'
  # for launching cross-platform applications
  gem 'launchy', '~> 2.5'
  # RSpec matchers and Cucumber steps for testing JSON content
  gem 'json_spec', '~> 1.1', '>= 1.1.5'
  # RSpec and Minitest matchers to prevent N+1 queries problem
  gem 'n_plus_one_control', '~> 0.6.2'
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '~> 3.36'
  gem 'selenium-webdriver'
  # Easy installation and use of chromedriver to run system tests with Chrome
  gem 'webdrivers'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[ mingw mswin x64_mingw jruby ]
