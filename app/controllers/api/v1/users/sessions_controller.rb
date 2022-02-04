module Api
  module V1
    module Users
      class SessionsController < Devise::SessionsController
        respond_to :json

        private

        def respond_with(resource, _opts = {})
          resource.id.present? ? login_success : login_failure
        end

        def respond_to_on_destroy
          current_user ? log_out_success : log_out_failure
        end

        def login_success
          render json: { message: 'You are logged in' }, status: :ok
        end

        def login_failure
          render json: { message: 'Logging in failed' }, status: :unprocessable_entity
        end

        def log_out_success
          render json: { message: 'Logged out' }, status: :ok
        end

        def log_out_failure
          render json: { message: 'Logged out failure.' }, status: :unauthorized
        end
      end
    end
  end
end
