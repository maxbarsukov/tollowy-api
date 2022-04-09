class Api::V1::AuthController < Api::V1::ApiController
  using StringToBoolean

  # POST /api/v1/auth/sign_in
  def sign_in
    result = Auth::SignIn.call(auth_params.merge({ request: request }))
    payload result, Auth::SignInPayload
  end

  # DELETE /api/v1/auth/sign_out
  def sign_out
    result = Auth::SignOut.call(
      token: token,
      user: current_user,
      everywhere: params[:everywhere]&.to_boolean
    )

    payload result, Auth::SignOutPayload
  end

  # POST /api/v1/auth/sign_up
  def sign_up
    result = Auth::SignUp.call(user_params: auth_params, request: request)
    payload result, Auth::SignUpPayload, status: :created
  end

  # GET /api/v1/auth/confirm
  def confirm
    result = User::Confirm.call(value: params.require(:confirmation_token))
    payload result, Auth::ConfirmPayload
  end

  # POST /api/v1/auth/reset_password
  def reset_password
    result = User::ResetPassword.call(reset_password_params)
    payload result, Auth::ResetPasswordPayload
  end

  # POST /api/v1/auth/request_password_reset
  def request_password_reset
    result = Auth::RequestPasswordReset.call(request_password_reset_params)
    payload result, Auth::RequestPasswordResetPayload
  end

  private

  def reset_password_params = json_params(%i[password reset_token])

  def request_password_reset_params = json_params(%i[email])

  def auth_params = json_params(%i[username email password])
end
