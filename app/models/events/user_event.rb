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
