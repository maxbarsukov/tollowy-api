# == Schema Information
#
# Table name: follows
#
#  id              :bigint           not null, primary key
#  blocked         :boolean          default(FALSE), not null
#  followable_type :string           not null
#  follower_type   :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  followable_id   :bigint           not null
#  follower_id     :bigint           not null
#
# Indexes
#
#  fk_followables                            (followable_id,followable_type)
#  fk_follows                                (follower_id,follower_type)
#  index_follows_on_created_at               (created_at)
#  index_follows_on_followable               (followable_type,followable_id)
#  index_follows_on_followable_and_follower  (followable_id,followable_type,follower_id,follower_type) UNIQUE
#  index_follows_on_follower                 (follower_type,follower_id)
#
class Follow < ApplicationRecord
  extend ActsAsFollower::FollowerLib
  extend ActsAsFollower::FollowScopes

  FOLLOWABLE_TYPES = ['User', 'Tag', Tag::NAME].freeze

  COUNTER_CULTURE_COLUMN_NAME_BY_TYPE = {
    'User' => 'following_users_count',
    'ActsAsTaggableOn::Tag' => 'following_tags_count'
  }.freeze

  COUNTER_CULTURE_COLUMNS_NAMES = {
    ['follows.followable_type = ?', 'User'] => 'following_users_count',
    ['follows.followable_type = ?', 'ActsAsTaggableOn::Tag'] => 'following_tags_count'
  }.freeze

  # Follows belong to the "followable" interface, and also to followers
  belongs_to :followable, polymorphic: true, counter_cache: 'followers_count'
  belongs_to :follower,   polymorphic: true, counter_cache: 'follow_count'

  scope :followable_user, ->(id) { where(followable_id: id, followable_type: 'User') }
  scope :followable_tag, ->(id) { where(followable_id: id, followable_type: 'ActsAsTaggableOn::Tag') }

  # NOTE: These assume that we have one follower_type (as defined by acts_as_follower).
  scope :follower_user, ->(id) { where(follower_id: id, followable_type: 'User') }
  scope :follower_tag, ->(id) { where(follower_id: id, followable_type: 'ActsAsTaggableOn::Tag') }

  counter_culture :follower,
                  column_name: proc { |follow| COUNTER_CULTURE_COLUMN_NAME_BY_TYPE[follow.followable_type] },
                  column_names: COUNTER_CULTURE_COLUMNS_NAMES

  after_save :touch_follower

  validates :blocked, inclusion: { in: [true, false] }
  validates :followable_type, presence: true, inclusion: { in: FOLLOWABLE_TYPES }
  validates :follower_type, presence: true

  def block!
    update_attribute(:blocked, true)
  end

  private

  def touch_follower
    follower.touch(:updated_at, :last_followed_at)
  end
end
