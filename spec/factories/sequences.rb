# frozen_string_literal: true

FactoryBot.define do
  sequence :user_email do |n|
    "user_#{n}@example.com"
  end
  sequence :event_title do |n|
    "User ##{n} registered!"
  end
end
