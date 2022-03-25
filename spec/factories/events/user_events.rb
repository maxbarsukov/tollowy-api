# frozen_string_literal: true

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
FactoryBot.define do
  factory :user_event, class: Events::UserEvent do
    title { generate(:event_title) }
    event { :user_registered }
    association :eventable, factory: :user

    trait :public do
      event { :user_registered }
    end

    trait :private do
      event { :user_updated }
    end
  end
end
