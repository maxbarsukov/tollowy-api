FactoryBot.define do
  factory :room do
    name { Faker::Company.name }
    is_private { [true, false].sample }
  end
end
