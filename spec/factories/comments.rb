# == Schema Information
#
# Table name: comments
#
#  id                      :bigint           not null, primary key
#  body                    :text
#  cached_votes_down       :integer          default(0)
#  cached_votes_score      :integer          default(0)
#  cached_votes_total      :integer          default(0)
#  cached_votes_up         :integer          default(0)
#  cached_weighted_average :float            default(0.0)
#  cached_weighted_score   :integer          default(0)
#  cached_weighted_total   :integer          default(0)
#  commentable_type        :string           not null
#  edited                  :boolean          default(FALSE)
#  edited_at               :datetime
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  commentable_id          :bigint           not null
#  user_id                 :bigint           not null
#
# Indexes
#
#  index_comments_on_commentable  (commentable_type,commentable_id)
#  index_comments_on_user_id      (user_id)
#
FactoryBot.define do
  factory :comment do
    body { Faker::Lorem.paragraph(sentence_count: 2) }
    commentable_type { 'Post' }
    commentable_id { create(:post, user:).id }
    association :user, factory: %i[user with_user_role]
  end
end
