class Api::V1::AuthController < Api::V1::ApiController
  using StringToBoolean

  # POST /api/v1/auth/sign_in
  def sign_in = action_for(:sign_in, auth_params.merge(request: request))

  # DELETE /api/v1/auth/sign_out
  def sign_out
    action_for(:sign_out, {
                 token: token,
                 user: current_user,
                 everywhere: params[:everywhere]&.to_boolean
               })
  end

  # POST /api/v1/auth/sign_up
  def sign_up = action_for(:sign_up, { user_params: auth_params, request: request }, :created)

  # GET /api/v1/auth/confirm
  def confirm = action_for(:confirm, value: params.require(:confirmation_token))

  # POST /api/v1/auth/reset_password
  def reset_password = action_for(:reset_password, reset_password_params)

  # POST /api/v1/auth/request_password_reset
  def request_password_reset = action_for(:request_password_reset, request_password_reset_params)

  private

  def reset_password_params = json_params(%i[password reset_token])

  def request_password_reset_params = json_params(%i[email])

  def auth_params = json_params(%i[username email password])
end
