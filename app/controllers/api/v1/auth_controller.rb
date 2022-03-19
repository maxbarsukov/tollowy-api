class Api::V1::AuthController < Api::V1::ApiController
  using StringToBoolean

  def sign_in
    result = Auth::SignIn.call(auth_params)
    payload result, Auth::SignInPayload
  end

  def sign_out
    result = Auth::SignOut.call(
      token: token,
      user: current_user,
      everywhere: params.require(:everywhere)&.to_boolean
    )

    payload result, Auth::SignOutPayload
  end

  def sign_up
    result = Auth::SignUp.call(user_params: auth_params)
    payload result, Auth::SignUpPayload, status: :created
  end

  def confirm
    result = User::Confirm.call(value: params.require(:confirmation_token))
    payload result, Auth::ConfirmPayload
  end

  private

  def auth_params
    json_params(%i[username email password])
  end
end
