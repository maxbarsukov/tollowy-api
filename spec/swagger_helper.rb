# frozen_string_literal: true

require 'rails_helper'

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
          response_auth_sign_in: {
            type: :object,
            properties: {
              data: {
                type: :object,
                properties: {
                  access_token: { type: :string },
                  refresh_token: { type: :string },
                  me: { '$ref' => '#/components/schemas/user' }
                },
                required: %w[access_token refresh_token me]
              }
            },
            required: ['data']
          },
          # /api/v1/auth/sign_out
          response_auth_sign_out: {
            type: :object,
            properties: {
              data: {
                type: :object,
                properties: {
                  message: { type: :string }
                },
                required: ['message']
              }
            },
            required: ['data']
          },
          response_auth_sign_out_401: { '$ref' => '#/components/schemas/invalid_credentials_error' },
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
          # /api/v1/auth/sign_out
          parameter_auth_sign_out: {
            type: :string, nullable: true,
            enum: %w[true false]
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
