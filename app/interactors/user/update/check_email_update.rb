class User::Update::CheckEmailUpdate
  include Interactor

  delegate :user_params, :user, to: :context

  def call
    return if user_params[:email].blank?

    # case-insensitive email equality check
    context.email_changed = !user.email.casecmp(user_params[:email]).zero?
  end
end
