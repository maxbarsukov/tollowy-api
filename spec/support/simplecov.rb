require 'coveralls'
require 'simplecov'
require 'simplecov-lcov'

unless ApplicationConfig['DONT_GENERATE_REPORT']
  SimpleCov.start 'rails' do
    add_filter 'app/admin'
    add_filter 'lib/constraints'
    add_filter 'app/controllers/api/v1/concerns/authenticable_user'

    SimpleCov::Formatter::LcovFormatter.config do |c|
      c.report_with_single_file = true
      c.single_report_path = 'coverage/lcov.info'
    end

    SimpleCov.formatters = [
      Coveralls::SimpleCov::Formatter,
      SimpleCov::Formatter::HTMLFormatter,
      SimpleCov::Formatter::LcovFormatter
    ]

    add_group 'Adapters', 'app/adapters'
    add_group 'Builders', 'app/builders'
    add_group 'Channels', 'app/channels'
    add_group 'Decorators', 'app/decorators'
    add_group 'Errors', 'app/errors'
    add_group 'Filters', 'app/filters'
    add_group 'Forms', 'app/forms'
    add_group 'Interactors', 'app/interactors'
    add_group 'Payloads', 'app/payloads'
    add_group 'Policies', 'app/policies'
    add_group 'Query Objects', 'app/query_objects'
    add_group 'Queries', 'app/queries'
    add_group 'Refinements', 'app/refinements'
    add_group 'Serializers', 'app/serializers'
    add_group 'Uploaders', 'app/uploaders'
    add_group 'Validators', 'app/validators'
  end

  Rails.application.eager_load!
end
