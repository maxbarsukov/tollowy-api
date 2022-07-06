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
class Comment < ApplicationRecord
  include Votable

  resourcify

  counter_culture :commentable
  counter_culture :user

  BODY_SIZE_RANGE = (1..10_000)

  COMMENTABLE_TYPES = %w[Post].freeze

  belongs_to :commentable, polymorphic: true
  belongs_to :user

  validates :body, presence: true, length: { in: BODY_SIZE_RANGE }
  validates :commentable_type, presence: true, inclusion: { in: COMMENTABLE_TYPES }
end
