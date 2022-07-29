class User::Update::AddMessage
  include Interactor

  delegate :email_changed, :is_another_user, :user, to: :context

  def call
    context.message = if email_changed && !is_another_user
                        I18n.t('user.update.email_changed', email: user.email)
                      else
                        I18n.t('user.update.success')
                      end
  end
end
