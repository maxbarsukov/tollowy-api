require 'coveralls'
require 'simplecov'

SimpleCov.start 'rails' do
  if ENV['CI']
    require 'simplecov-lcov'

    SimpleCov::Formatter::LcovFormatter.config do |c|
      c.report_with_single_file = true
      c.single_report_path = 'coverage/lcov.info'
    end

    SimpleCov.formatters = [
      Coveralls::SimpleCov::Formatter,
      SimpleCov::Formatter::LcovFormatter
    ]

  else
    SimpleCov.formatters = [
      Coveralls::SimpleCov::Formatter,
      SimpleCov::Formatter::HTMLFormatter
    ]
  end

  add_group 'Channels', 'app/channels'
  add_group 'Errors', 'app/errors'
  add_group 'Forms', 'app/forms'
  add_group 'Interactors', 'app/interactors'
  add_group 'Policies', 'app/policies'
  add_group 'Query Objects', 'app/query_objects'
  add_group 'Refinements', 'app/refinements'
  add_group 'Serializers', 'app/serializers'
  add_group 'Validators', 'app/validators'
end
