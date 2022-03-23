# frozen_string_literal: true

require 'active_support'
require 'active_support/testing/time_helpers'
require 'n_plus_one_control/rspec'

if ENV['CRYSTALBALL'] == 'true' && ENV['DONT_GENERATE_REPORT'] == 'true'
  require 'crystalball'
  require 'crystalball/rails'

  Crystalball::MapGenerator.start! do |config|
    config.register Crystalball::MapGenerator::CoverageStrategy.new
    config.register Crystalball::Rails::MapGenerator::I18nStrategy.new
    config.register Crystalball::MapGenerator::DescribedClassStrategy.new
  end
end

RSpec.configure do |config|
  config.include ActiveSupport::Testing::TimeHelpers

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
end
