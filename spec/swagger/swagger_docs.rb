# rubocop:disable Metrics/MethodLength, Metrics/ModuleLength
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
            # Models
            **generate_models,

            # Responses
            **generate_responses,

            # Parameters
            parameter_auth_sign_in: {
              type: :object,
              properties: {
                data: {
                  type: :object,
                  properties: {
                    type: { type: :string, enum: ['auth'] },
                    attributes: {
                      type: :object,
                      properties: {
                        email: { type: :string },
                        password: { type: :string }
                      },
                      required: %w[email password]
                    }
                  },
                  required: %w[type attributes]
                }
              }
            },
            # /api/v1/auth/sign_up
            parameter_auth_sign_up: {
              type: :object,
              properties: {
                data: {
                  type: :object,
                  properties: {
                    type: { type: :string, enum: ['auth'] },
                    attributes: {
                      type: :object,
                      properties: {
                        email: { type: :string },
                        username: { type: :string },
                        password: { type: :string }
                      },
                      required: %w[email username password]
                    }
                  },
                  required: %w[type attributes]
                }
              }
            },
            # /api/v1/auth/sign_out
            parameter_auth_sign_out: {
              type: :string, nullable: true,
              enum: %w[true false]
            },
            # /api/v1/auth/request_password_reset
            parameter_request_password_reset: {
              type: :object,
              properties: {
                data: {
                  type: :object,
                  properties: {
                    type: { type: :string, enum: ['auth'] },
                    attributes: {
                      type: :object,
                      properties: {
                        email: { type: :string }
                      },
                      required: %w[email]
                    }
                  },
                  required: %w[type attributes]
                }
              }
            },
            # /api/v1/auth/reset_password
            parameter_reset_password: {
              type: :object,
              properties: {
                data: {
                  type: :object,
                  properties: {
                    type: { type: :string, enum: ['auth'] },
                    attributes: {
                      type: :object,
                      properties: {
                        password: { type: :string },
                        reset_token: { type: :string }
                      },
                      required: %w[password reset_token]
                    }
                  },
                  required: %w[type attributes]
                }
              }
            },
            # /api/v1/auth/users/{id}
            parameter_update_user: {
              **SwaggerGenerator.generate_data(
                'user',
                attr: {
                  properties: {
                    current_password: {
                      description: 'Current password',
                      type: :string
                    },
                    password: {
                      description: 'New password',
                      type: :string
                    },
                    email: { type: :string },
                    username: { type: :string },
                    role: {
                      oneOf: [
                        { '$ref' => '#/components/schemas/role_value' },
                        { '$ref' => '#/components/schemas/role_name' }
                      ]
                    }
                  }
                }
              )
            },
            # POST /api/v1/posts
            parameter_posts_create: {
              **SwaggerGenerator.generate_data(
                'post',
                attr: {
                  properties: {
                    body: {
                      description: 'Post body',
                      type: :string
                    }
                  }
                }
              )
            }
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

  def generate_responses
    puts
    {}.tap do |responses|
      Dir[Rails.root.join('spec/swagger/schemas/response/**/*.rb')].each do |f|
        file_name = f.delete_prefix("#{__dir__}/schemas/response/").delete_suffix('.rb')
        klass = "Schemas::Response::#{file_name.classify}".constantize

        responses[klass.title.to_sym] = klass.data
      end
    end
  end
end
# rubocop:enable Metrics/MethodLength, Metrics/ModuleLength
