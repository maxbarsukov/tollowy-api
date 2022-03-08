# frozen_string_literal: true

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
