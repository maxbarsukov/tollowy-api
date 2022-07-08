# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  avatar                 :string
#  comments_count         :integer          default(0), not null
#  confirmed_at           :datetime
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :string
#  email                  :citext           not null
#  follow_count           :integer          default(0), not null
#  followers_count        :integer          default(0), not null
#  following_tags_count   :integer          default(0), not null
#  following_users_count  :integer          default(0), not null
#  last_followed_at       :datetime
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :string
#  password_digest        :string           not null
#  password_reset_sent_at :datetime
#  password_reset_token   :string
#  posts_count            :integer          default(0), not null
#  sign_in_count          :integer          default(0), not null
#  username               :string           not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_password_reset_token  (password_reset_token) UNIQUE
#  index_users_on_username              (username) UNIQUE
#
class User < ApplicationRecord
  include Eventable
  include Rolified

  include UserValidator

  events_class ::Events::UserEvent

  acts_as_voter
  acts_as_tagger
  acts_as_follower
  acts_as_followable

  # NOTE: undefine `acts_as_follower` methods, define own counters
  undef_method :follow_count
  undef_method :followers_count

  has_secure_password
  has_secure_token :password_reset_token

  mount_uploader :avatar, AvatarUploader

  has_many :refresh_tokens, dependent: :delete_all
  has_many :possession_tokens, dependent: :delete_all

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy

  after_create :assign_default_role

  private

  def assign_default_role
    @role = add_role(:unconfirmed) unless role
  end
end
