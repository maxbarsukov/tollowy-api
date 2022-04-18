# rubocop:disable Naming/VariableNumber, Metrics/MethodLength, Metrics/ModuleLength
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
            role_value: Schemas::RoleValue.data,
            role_name: Schemas::RoleName.data,
            role: Schemas::Role.data,
            users: Schemas::Users.data,
            user: Schemas::User.data,
            user_attributes: Schemas::UserAttributes.data,
            posts: Schemas::Posts.data,
            post: Schemas::Post.data,
            post_attributes: Schemas::PostAttributes.data,
            post_relationships: Schemas::PostRelationships.data,
            auth: Schemas::Auth.data,
            error: Schemas::Error.data,
            unauthorized_error: Schemas::UnauthorizedError.data,
            you_must_be_logged_in: Schemas::YouMustBeLoggedIn.data,
            invalid_credentials_error: Schemas::InvalidCredentialsError.data,
            invalid_value: Schemas::InvalidValue.data,
            param_is_missing: Schemas::ParamIsMissing.data,
            record_is_invalid: Schemas::RecordIsInvalid.data,
            user_not_found_error: Schemas::UserNotFoundError.data,
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
              **SwaggerGenerator.generate_data(
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
              **SwaggerGenerator.generate_data(
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
              **SwaggerGenerator.generate_data(
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
            # /api/v1/posts
            response_posts_get: {
              type: :object,
              properties: {
                data: { '$ref' => '#/components/schemas/posts' }
              },
              required: ['data']
            },
            # /api/v1/posts/{id}
            response_post: {
              type: :object,
              properties: {
                data: { '$ref' => '#/components/schemas/post' }
              },
              required: ['data']
            },
            # DELETE /api/v1/posts/{id}
            response_post_delete: {
              **SwaggerGenerator.generate_data(
                'post',
                meta: {
                  properties: {
                    message: { type: :string }
                  },
                  required: %w[message]
                }
              )
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
end
# rubocop:enable Naming/VariableNumber, Metrics/MethodLength, Metrics/ModuleLength
