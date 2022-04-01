# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable Metrics/MethodLength,Metrics/AbcSize
module SwaggerHelper
  def self.generate_data(type, attr: nil, meta: nil)
    data = create_basic_data(type)

    if meta
      data[:properties][:data][:properties][:meta] = { type: :object, **meta }
      data[:properties][:data][:required] << 'meta'
    end

    if attr
      data[:properties][:data][:properties][:attributes] = { type: :object, **attr }
      data[:properties][:data][:required] << 'attributes'
    end
    data
  end

  def self.create_basic_data(type)
    {
      type: :object,
      properties: {
        data: {
          type: :object,
          properties: { type: { type: :string, enum: [type] } },
          required: %w[type]
        }
      },
      required: ['data']
    }
  end
end
# rubocop:enable Metrics/MethodLength,Metrics/AbcSize

# rubocop:disable Naming/VariableNumber Metrics/BlockLength
RSpec.configure do |config| # rubocop:disable Metrics/BlockLength
  # Specify a root folder where Swagger JSON files are generated
  # NOTE: If you're using the rswag-api to serve API descriptions, you'll need
  # to ensure that it's configured to serve Swagger from the same folder
  config.swagger_root = Rails.root.join('docs/swagger').to_s

  # Define one or more Swagger documents and provide global metadata for each one
  # When you run the 'rswag:specs:swaggerize' rake task, the complete Swagger will
  # be generated at the provided relative path under swagger_root
  # By default, the operations defined in spec files are added to the first
  # document below. You can override this behavior by adding a swagger_doc tag to the
  # the root example_group in your specs, e.g. describe '...', swagger_doc: 'v2/swagger.json'
  config.swagger_docs = {
    'v1/swagger.json' => {
      openapi: '3.0.0',
      info: {
        title: 'API V1',
        version: 'v1'
      },
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
          role_value: {
            title: 'Role Value',
            enum: [-30, -20, -10, 0, 10, 20, 30, 40, 50],
            type: :integer,
            description: 'An enumeration'
          },
          role: {
            title: 'Role',
            description: 'Role',
            type: :object,
            properties: {
              name: { type: :string },
              value: { '$ref' => '#/components/schemas/role_value' }
            },
            required: %w[name value]
          },
          users: {
            title: 'Users',
            description: 'Users',
            type: :array,
            items: { '$ref' => '#/components/schemas/user' }
          },
          user: {
            title: 'User',
            description: 'User object',
            type: :object,
            properties: {
              id: { type: :string },
              type: { type: :string },
              attributes: { '$ref' => '#/components/schemas/user_attributes' }
            },
            required: %w[id type]
          },
          user_attributes: {
            title: 'User Attributes',
            description: 'Attributes for User',
            type: :object,
            properties: {
              email: { type: :string },
              username: { type: :string },
              created_at: { type: :string },
              role: { '$ref' => '#/components/schemas/role' }
            },
            required: %w[email username created_at role]
          },
          error: {
            title: 'Error',
            description: 'JSON:API Error response',
            type: :object,
            properties: {
              errors: {
                type: :array,
                items: {
                  type: :object,
                  properties: {
                    status: { type: :string },
                    code: { type: :string },
                    title: { type: :string },
                    detail: { type: :string }
                  },
                  required: %w[status code title]
                }
              }
            },
            required: ['errors']
          },
          auth: {
            title: 'Auth Data',
            **SwaggerHelper.generate_data(
              'auth',
              attr: {
                properties: {
                  access_token: { type: :string },
                  refresh_token: { type: :string },
                  me: { '$ref' => '#/components/schemas/user' }
                },
                required: %w[access_token refresh_token me]
              }
            )
          },
          unauthorized_error: {
            title: 'Unauthorized Error',
            description: 'User must sign in before continuing',
            type: :object,
            properties: {
              errors: {
                type: :array,
                items: {
                  type: :object,
                  properties: {
                    status: { type: :string, enum: ['401'] },
                    code: { type: :string, enum: ['unauthorized'] },
                    title: { type: :string, enum: ['You need to sign in or sign up before continuing'] }
                  },
                  required: %w[status code title]
                }
              }
            },
            required: ['errors']
          },
          invalid_credentials_error: {
            title: 'Invalid Credentials Error',
            description: "User's token is invalid",
            type: :object,
            properties: {
              errors: {
                type: :array,
                items: {
                  type: :object,
                  properties: {
                    status: { type: :string, enum: ['401'] },
                    code: { type: :string, enum: ['unauthorized'] },
                    title: { type: :string, enum: ['Invalid credentials'] }
                  },
                  required: %w[status code title]
                }
              }
            },
            required: ['errors']
          },
          invalid_value: {
            title: 'Invalid Value Error',
            type: :object,
            properties: {
              errors: {
                type: :array,
                items: {
                  type: :object,
                  properties: {
                    status: { type: :string, enum: ['400'] },
                    code: { type: :string, enum: ['bad_request'] },
                    title: { type: :string, enum: ['Invalid value'] }
                  },
                  required: %w[status code title]
                }
              }
            },
            required: ['errors']
          },
          param_is_missing: {
            title: 'Param is missing or the value is empty',
            type: :object,
            properties: {
              errors: {
                type: :array,
                items: {
                  type: :object,
                  properties: {
                    status: { type: :string, enum: ['422'] },
                    code: { type: :string, enum: ['unprocessable_entity'] },
                    title: { type: :string }
                  },
                  required: %w[status code title]
                }
              }
            },
            required: ['errors']
          },
          user_not_found_error: {
            title: 'User Not Found',
            description: 'User ID is invalid',
            type: :object,
            properties: {
              errors: {
                type: :array,
                items: {
                  type: :object,
                  properties: {
                    status: { type: :string, enum: ['404'] },
                    code: { type: :string, enum: ['not_found'] },
                    title: { type: :string, enum: ['Not Found'] }
                  },
                  required: %w[status code title]
                }
              }
            }
          },
          # Responses
          # /api/v1/
          response_root_get: {
            type: :object,
            properties: {
              message: { type: :string, enum: ["If you see this, you're in!"] }
            },
            required: ['message']
          },
          response_root_get_401: { '$ref' => '#/components/schemas/unauthorized_error' },
          # /api/v1/auth/sign_in
          response_auth_sign_in: { '$ref' => '#/components/schemas/auth' },
          # /api/v1/auth/sign_up
          response_auth_sign_up: { '$ref' => '#/components/schemas/auth' },
          # /api/v1/auth/sign_out
          response_auth_sign_out: {
            **SwaggerHelper.generate_data(
              'auth',
              meta: {
                properties: {
                  message: { type: :string }
                },
                required: ['message']
              }
            )
          },
          response_auth_sign_out_401: { '$ref' => '#/components/schemas/invalid_credentials_error' },
          # /api/v1/auth/confirm
          response_auth_confirm: {
            **SwaggerHelper.generate_data(
              'auth',
              attr: {
                properties: {
                  me: { '$ref' => '#/components/schemas/user' }
                },
                required: ['me']
              }
            )
          },
          # /api/v1/auth/request_password_reset
          response_request_password_reset: {
            **SwaggerHelper.generate_data(
              'auth',
              meta: {
                properties: {
                  message: { type: :string },
                  detail: { type: :string }
                },
                required: %w[message detail]
              }
            )
          },
          # /api/v1/users
          response_users_get: {
            type: :object,
            properties: {
              data: { '$ref' => '#/components/schemas/users' }
            },
            required: ['data']
          },
          # /api/v1/users/{id}
          response_users_id_get_404: { '$ref' => '#/components/schemas/user_not_found_error' },
          response_users_id_get: {
            type: :object,
            properties: {
              data: { '$ref' => '#/components/schemas/user' }
            },
            required: ['data']
          },
          # Parameters
          # /api/v1/auth/sign_in
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
          }
        }
      }
    }
  }

  # Specify the format of the output Swagger file when running 'rswag:specs:swaggerize'.
  # The swagger_docs configuration option has the filename including format in
  # the key, this may want to be changed to avoid putting yaml in json files.
  # Defaults to json. Accepts ':json' and ':yaml'.
  config.swagger_format = :json
end
# rubocop:enable Naming/VariableNumber
