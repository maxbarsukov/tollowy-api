require 'coveralls'
require 'simplecov'

SimpleCov.formatters = [
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]

SimpleCov.start 'rails' do
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
