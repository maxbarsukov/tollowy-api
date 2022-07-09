class Api::V1::ApiController < BaseController
  Concerns = Api::V1::Concerns

  include Concerns::AuthenticableUser
  include Concerns::ErrorHandler
  include Concerns::Interactable
  include Concerns::JsonParams
  include Concerns::Paginator
  include Concerns::Payload
  include Concerns::PunditAuthorizer
  include Concerns::QueryParams
  include Concerns::Response
end
