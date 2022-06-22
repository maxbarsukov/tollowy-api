# == Schema Information
#
# Table name: comments
#
#  id               :bigint           not null, primary key
#  ancestry         :string
#  ancestry_depth   :integer          default(0)
#  body             :text
#  children_count   :integer          default(0)
#  commentable_type :string           not null
#  deleted          :boolean          default(FALSE)
#  edited           :boolean          default(FALSE)
#  edited_at        :datetime
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  commentable_id   :bigint           not null
#  user_id          :bigint           not null
#
# Indexes
#
#  index_comments_on_ancestry     (ancestry)
#  index_comments_on_commentable  (commentable_type,commentable_id)
#  index_comments_on_user_id      (user_id)
#
FactoryBot.define do
  factory :comment do
    body { Faker::Lorem.paragraph(sentence_count: 2) }
    commentable_type { 'Post' }
    commentable_id { create(:post, user: user).id }
    association :user, factory: %i[user with_user_role]
  end
end
