module Api::V1
  class ApiController < ApplicationController
    include Concerns::ErrorHandler
    include Concerns::Response
    include Concerns::AuthenticableUser
  end
end
