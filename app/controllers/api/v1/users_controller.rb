module Api::V1
  class UsersController < Api::V1::ApiController
    before_action :set_user, only: %i[show update]

    def index
      @users = User.includes(%i[roles roles_users])
      json_response UserSerializer.call(@users)
    end

    def show
      json_response UserSerializer.call(@user)
    end

    def update
      authorize @user
      result = User::Update.call(user: @user, user_params: user_params)

      if result.success?
        json_response UserSerializer.call(result.user)
      else
        json_error result.error_data
      end
    end

    private

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.permit(:username, :email, :password, :current_password)
    end
  end
end
