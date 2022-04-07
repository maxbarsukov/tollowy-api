module Api::V1
  class ApiController < BaseController
    include Concerns::ErrorHandler
    include Concerns::Response
    include Concerns::AuthenticableUser
    include Concerns::Payload
    include Concerns::PunditAuthorizer
    include Concerns::JsonParams
  end
end
