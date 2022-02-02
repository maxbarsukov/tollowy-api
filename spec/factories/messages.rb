FactoryBot.define do
  factory :message do
    association :user, factory: :user
    association :room, factory: :room
    content { Faker::Lorem.sentence(word_count: 10) }
  end
end
