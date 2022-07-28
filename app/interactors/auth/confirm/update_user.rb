class Auth::Confirm::UpdateUser
  include Interactor

  delegate :token, to: :context

  def call
    user.update(confirmed_at: Time.current)
    update_role!
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

  def user
    context.user ||= token.user
  end
end
