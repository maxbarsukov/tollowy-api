require 'rails/generators'

# rubocop:disable Style/IfUnlessModifier
class SwaggerSchema < Rails::Generators::NamedBase
  source_root File.expand_path('templates', __dir__)

  class_option :type, type: :string, default: 'models'

  def create_schema_file
    unless options[:type].in? %w[model response parameter]
      raise "Invalid Schema Type passed. Must be in [models, response, parameter]; got #{options[:type]}"
    end

    @type_name = options[:type]
    @not_models = options[:type] != 'models'

    @module_name = @not_models ? options[:type].titleize : ''
    @class_name = @not_models ? class_name : class_name.demodulize

    generator_path = create_path

    template 'schema_template.erb', generator_path
  end

  private

  def create_path
    schema_dir_path = 'spec/swagger/schemas'
    generator_dir_path = "#{schema_dir_path}/#{@type_name}"

    FileUtils.mkdir_p(schema_dir_path)
    FileUtils.mkdir_p(generator_dir_path)

    "#{generator_dir_path}/#{file_path}.rb"
  end
end
# rubocop:enable Style/IfUnlessModifier

class Generators::SwaggerSchema::SwaggerSchemaGenerator; end # rubocop:disable Lint/EmptyClass
