FactoryBot.define do
  factory :comment do
    body { Faker::Lorem.paragraph(sentence_count: 2) }
    commentable_type { 'Post' }
    commentable_id { create(:post, user: user).id }
    association :user, factory: %i[user with_user_role]
  end
end
