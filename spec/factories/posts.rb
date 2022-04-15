# == Schema Information
#
# Table name: posts
#
#  id         :bigint           not null, primary key
#  body       :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_posts_on_user_id  (user_id)
#
FactoryBot.define do
  factory :post do
    body { Faker::Lorem.paragraph(sentence_count: 2) }

    association :user, factory: %i[user with_user_role]
  end
end
