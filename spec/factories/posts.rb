# == Schema Information
#
# Table name: posts
#
#  id                      :bigint           not null, primary key
#  body                    :text             not null
#  cached_votes_down       :integer          default(0)
#  cached_votes_score      :integer          default(0)
#  cached_votes_total      :integer          default(0)
#  cached_votes_up         :integer          default(0)
#  cached_weighted_average :float            default(0.0)
#  cached_weighted_score   :integer          default(0)
#  cached_weighted_total   :integer          default(0)
#  comments_count          :integer          default(0), not null
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  user_id                 :bigint           not null
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
