FactoryBot.define do
  factory :participant do
    association :user, factory: :user
    association :room, factory: :room
  end
end
