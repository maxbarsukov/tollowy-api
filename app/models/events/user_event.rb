# == Schema Information
#
# Table name: events
#
#  id             :bigint           not null, primary key
#  event          :string           not null
#  eventable_type :string           not null
#  title          :string           not null
#  type           :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  eventable_id   :bigint           not null
#
# Indexes
#
#  index_events_on_eventable  (eventable_type,eventable_id)
#
class Events::UserEvent < Events::Event
  EVENTS = %i[
    user_registered
    user_logged_in
    user_updated
    reset_password_requested
    user_reset_password
  ].freeze

  enumerize :event, in: EVENTS

  scope :public_events, -> { where(event: %i[user_registered user_logged_in]) }
end
