module Api
  module V1
    class UsersController < Api::V1::ApiController
      before_action :set_user, only: %i[show]

      def index
        @users = User.all
        render json: UserSerializer.new(@users), status: :ok
      end

      def show
        render json: UserSerializer.new(@user), status: :ok
      end

      private

      def set_user
        @user = User.find(params[:id])
      end
    end
  end
end
