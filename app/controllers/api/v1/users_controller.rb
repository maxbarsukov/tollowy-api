module Api
  module V1
    class UsersController < Api::V1::ApiController
      before_action :set_user, only: %i[show]

      def index
        @users = User.all
        json_response UserSerializer.new(@users)
      end

      def show
        json_response UserSerializer.new(@user)
      end

      private

      def set_user
        @user = User.find(params[:id])
      end
    end
  end
end
