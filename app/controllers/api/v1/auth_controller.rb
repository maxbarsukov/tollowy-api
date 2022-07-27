class Api::V1::AuthController < Api::V1::ApiController
  using StringToBoolean

  # POST /api/v1/auth/sign_in
  def sign_in = action_for(:sign_in, params_for(sign_in_params.merge(request:)))

  # DELETE /api/v1/auth/sign_out
  def sign_out
    action_for(:sign_out, params_for({ user: current_user, everywhere: params[:everywhere]&.to_boolean }))
  end

  # POST /api/v1/auth/sign_up
  def sign_up = action_for(:sign_up, params_for({ user_params: sign_up_params, request: }), :created)

  # GET /api/v1/auth/confirm
  def confirm = action_for(:confirm, params_for(value: params.require(:confirmation_token)))

  # GET /api/v1/auth/resend_confirm
  def resend_confirm = action_for(:resend_confirm)

  # GET /api/v1/auth/confirm
  def refresh = action_for(:update_token_pair, params_for({ user: current_user }))

  # POST /api/v1/auth/providers/github
  def github_auth
    action_for(:github_auth, params_for(github_token_enc: params.require(:token), provider: 'GitHub', request:))
  end

  # POST /api/v1/auth/providers/vk
  def vk_auth
    action_for(
      :vk_auth,
      params_for(
        vk_code_enc: params.require(:vk_code),
        vk_redirect_uri: params.require(:vk_redirect_uri),
        email: params[:email],
        provider: 'VK',
        request:
      )
    )
  end

  # POST /api/v1/auth/reset_password
  def reset_password = action_for(:reset_password, params_for(reset_password_params))

  # POST /api/v1/auth/request_password_reset
  def request_password_reset = action_for(:request_password_reset, params_for(request_password_reset_params))

  private

  def reset_password_params = json_params(%i[password reset_token])

  def request_password_reset_params = json_params(%i[email])

  def sign_in_params = json_params(%i[username_or_email password])

  def sign_up_params = json_params(%i[username email password])

  def params_for(hash)
    { token:, token_payload: jwt_payload }.merge(hash)
  end
end
