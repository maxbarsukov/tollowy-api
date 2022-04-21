# rubocop:disable Naming/VariableNumber, Metrics/MethodLength, Metrics/ModuleLength, Metrics/AbcSize
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
            pagination_error: Schemas::PaginationError.data,
            pagination_links: Schemas::PaginationLinks.data,
            pagination_meta: Schemas::PaginationMeta.data,

            # Responses
            response_root_index: Schemas::Response::Root::Index.data,
            response_root_index_401: Schemas::Response::Root::Index401.data,

            response_auth_sign_in: Schemas::Response::Auth::SignIn.data,
            response_auth_sign_up: Schemas::Response::Auth::SignUp.data,
            response_auth_sign_out: Schemas::Response::Auth::SignOut.data,
            response_auth_sign_out_401: Schemas::Response::Auth::SignOut401.data,
            response_auth_confirm: Schemas::Response::Auth::Confirm.data,
            response_auth_request_password_reset: Schemas::Response::Auth::RequestPasswordReset.data,

            response_users_index: Schemas::Response::Users::Index.data,
            response_users_show: Schemas::Response::Users::Show.data,
            response_users_show_404: Schemas::Response::Users::Show404.data,
            response_users_update: Schemas::Response::Users::Update.data,

            response_posts_index: Schemas::Response::Posts::Index.data,
            response_posts_show: Schemas::Response::Posts::Show.data,
            response_posts_destroy: Schemas::Response::Posts::Destroy.data,

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
end
# rubocop:enable Naming/VariableNumber, Metrics/MethodLength, Metrics/ModuleLength, Metrics/AbcSize
