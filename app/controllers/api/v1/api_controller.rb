module Api::V1
  class ApiController < ApplicationController
    include Concerns::ErrorHandler
    include Concerns::Response
    include Concerns::AuthenticableUser
    include Concerns::Payload
  end
end
