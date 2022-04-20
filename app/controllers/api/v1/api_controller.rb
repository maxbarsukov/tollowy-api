class Api::V1::ApiController < BaseController
  Concerns = Api::V1::Concerns

  include Concerns::ErrorHandler
  include Concerns::Response
  include Concerns::AuthenticableUser
  include Concerns::Payload
  include Concerns::PunditAuthorizer
  include Concerns::JsonParams
  include Concerns::Paginator
end
