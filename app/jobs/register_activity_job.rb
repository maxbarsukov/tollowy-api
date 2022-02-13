class RegisterActivityJob < ApplicationJob
  queue_as :events

  def perform(user_id, event)
    user = User.find(user_id)
    Activity::Create.call!(user: user, event: event)
  end
end
