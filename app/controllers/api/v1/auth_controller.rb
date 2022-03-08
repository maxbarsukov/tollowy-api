class Api::V1::AuthController < Api::V1::ApiController
  using StringToBoolean

  def sign_in
    result = Auth::SignIn.call(auth_params)
    if result.success?
      json_response({
                      access_token: result.access_token,
                      refresh_token: result.refresh_token,
                      me: UserSerializer.new(result.user)
                    })
    else
      json_error result.error_data
    end
  end

  def sign_out
    Auth::SignOut.call(
      token: token,
      user: current_user,
      everywhere: params[:everywhere]&.to_boolean
    )

    json_response({ message: 'User signed out successfully' })
  end

  def sign_up
    result = Auth::SignUp.call(user_params: auth_params)

    if result.success?
      json_response({
                      access_token: result.access_token,
                      refresh_token: result.refresh_token,
                      me: UserSerializer.new(result.user)
                    })
    else
      json_error result.error_data
    end
  end

  private

  def auth_params
    params.permit(:username, :email, :password)
  end
end
