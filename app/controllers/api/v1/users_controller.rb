module Api
  module V1
    class UsersController < Api::V1::ApiController
      def index
        @users = User.all
        render json: @users, status: :ok
      end

      def show
        @user = User.find(params[:id])
        render json: { success: true, data: { user: @user } }, status: :ok
      end
    end
  end
end
