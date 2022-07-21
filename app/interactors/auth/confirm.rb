class Auth::Confirm
  include Interactor

  delegate :value, to: :context

  def call
    context.fail!(error_data:) if token.blank?

    user.update(confirmed_at: Time.current)

    update_role!
    token.destroy!
  end

  private

  def update_role!
    if user.role_before_reconfirm_value.present?
      user.role = user.role_before_reconfirm_value
      user.role_before_reconfirm_value = nil
      user.save!
    else
      user.role = :user
    end
  end

  def token
    @token ||= PossessionToken.find_by(value:)
  end

  def user
    context.user ||= token.user
  end

  def error_data
    ErrorData.new(
      status: 400,
      code: :bad_request,
      title: 'Invalid value'
    )
  end
end
