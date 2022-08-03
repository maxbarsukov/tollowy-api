class User::Events::Create
  include Interactor

  delegate :user, :event, :provider, to: :context
  delegate :username, :email, to: :user

  def call
    user.events.create!(event_attributes)
  end

  private

  def event_attributes
    {
      event:,
      title: event_title
    }
  end

  def event_title
    I18n.t("models.user.events.#{event}", username:, email:, provider:)
  end
end
