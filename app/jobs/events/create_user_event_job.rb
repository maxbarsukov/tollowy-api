class Events::CreateUserEventJob < ApplicationJob
  queue_as :events

  def perform(user_id, event)
    user = User.find(user_id)
    User::Events::Create.call!(user: user, event: event)
  end
end
