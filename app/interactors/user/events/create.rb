class User::Events::Create
  include Interactor

  delegate :user, :event, to: :context

  def call
    user.events.create!(event_attributes)
  end

  private

  def event_attributes
    {
      event: event,
      title: event_title
    }
  end

  def event_title
    I18n.t("user.events.#{event}", username: user.username, email: user.email)
  end
end
