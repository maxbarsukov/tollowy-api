class Events::CreateUserEventJob < ApplicationJob
  queue_as :events

  def perform(user_id, event, provider = nil)
    user = User.find(user_id)
    User::Events::Create.call!(user:, event:, provider:)
  end
end
