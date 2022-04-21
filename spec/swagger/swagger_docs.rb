module SwaggerDocs
  module_function

  def generate
    {
      'v1/swagger.json' => {
        openapi: '3.0.0',
        info: {
          title: 'API V1',
          version: 'v1'
        },
        servers: [
          {
            url: '/api/{api_version}',
            variables: {
              api_version: {
                default: 'v1',
                enum: ['v1']
              }
            }
          }
        ],
        components: {
          securitySchemes: {
            Bearer: {
              type: :http,
              description: 'Bearer Token',
              scheme: :bearer,
              bearerFormat: 'JWT'
            }
          },
          schemas: {
            **generate_models,
            **generate_responses,
            **generate_parameters
          }
        }
      }
    }
  end

  def generate_models
    {}.tap do |models|
      Dir[Rails.root.join('spec/swagger/schemas/models/**/*.rb')].each do |f|
        file_name = File.basename(f, '.rb')
        class_name = file_name.gsub(/^[a-z0-9]|_[a-z0-9]/, &:upcase).delete('_')

        klass = "Schemas::#{class_name}".constantize
        models[klass.title.to_sym] = klass.data
      end
    end
  end

  def generate_responses = generate_schema('response')

  def generate_parameters = generate_schema('parameter')

  def generate_schema(schema_name)
    {}.tap do |entities|
      Dir[Rails.root.join("spec/swagger/schemas/#{schema_name}/**/*.rb")].each do |f|
        file_name = f.delete_prefix("#{__dir__}/schemas/#{schema_name}/").delete_suffix('.rb')
        klass = "Schemas::#{schema_name.titleize}::#{file_name.classify}".constantize

        entities[klass.title.to_sym] = klass.data
      end
    end
  end
end
