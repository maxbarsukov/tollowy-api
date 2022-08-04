# == Schema Information
#
# Table name: users
#
#  id                          :bigint           not null, primary key
#  avatar                      :string
#  bio                         :text
#  blog                        :string
#  comments_count              :integer          default(0), not null
#  confirmed_at                :datetime
#  current_sign_in_at          :datetime
#  current_sign_in_ip          :string
#  email                       :citext           not null
#  follow_count                :integer          default(0), not null
#  followers_count             :integer          default(0), not null
#  following_tags_count        :integer          default(0), not null
#  following_users_count       :integer          default(0), not null
#  last_followed_at            :datetime
#  last_sign_in_at             :datetime
#  last_sign_in_ip             :string
#  location                    :string
#  password_digest             :string           not null
#  password_reset_sent_at      :datetime
#  password_reset_token        :string
#  posts_count                 :integer          default(0), not null
#  role_before_reconfirm_value :integer
#  sign_in_count               :integer          default(0), not null
#  username                    :string           not null
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_password_reset_token  (password_reset_token) UNIQUE
#  index_users_on_username              (username) UNIQUE
#
class User < ApplicationRecord
  extend Pagy::Searchkick

  include Eventable
  include Rolified
  include Followable

  include UserValidator

  events_class ::Events::UserEvent

  searchkick word_middle: %i[username email], language: 'russian'

  acts_as_voter
  acts_as_tagger
  acts_as_follower

  # NOTE: undefine `acts_as_follower` methods, define own counters
  undef_method :follow_count

  has_secure_password
  has_secure_token :password_reset_token

  mount_uploader :avatar, AvatarUploader

  has_many :refresh_tokens, dependent: :delete_all
  has_many :possession_tokens, dependent: :delete_all
  has_many :providers, dependent: :delete_all

  has_many :ip_addresses, dependent: :nullify

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy

  after_create :assign_default_role

  def make_unconfirmed!
    return if unconfirmed?

    before_role = role_before_reconfirm_value.presence || -Float::INFINITY
    self.role_before_reconfirm_value = [before_role, role_value].max
    self.role = :unconfirmed
    save!
  end

  def following_users
    User.where(id: following_by_type('User').pluck(:id))
  end

  def following_tags
    Tag.where(id: following_by_type(Tag::NAME, { model: Tag }).pluck(:id))
  end

  def self.following_for_current_user(scope, current_user_id)
    scope
      .joins(
        sanitize_sql_array(
          [
            'LEFT JOIN follows ON follows.followable_id = users.id ' \
            "AND follows.follower_id = ? AND follows.blocked = FALSE AND follows.followable_type = 'User'",
            current_user_id
          ]
        )
      )
      .select('users.*, follows.id IS NOT NULL AS am_i_follow')
      .group('am_i_follow, users.id')
  end

  private

  def assign_default_role
    @role = add_role(:unconfirmed) unless role
  end
end
