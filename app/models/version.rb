# == Schema Information
#
# Table name: versions
#
#  id         :bigint           not null, primary key
#  for_role   :string           default("all"), not null
#  link       :string           not null
#  size       :integer          not null
#  v          :string           not null
#  whats_new  :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_versions_on_v  (v) UNIQUE
#
class Version < ApplicationRecord
  AVAILABLE_FOR_ROLE = %w[all user premium primary moderator admin dev].freeze
  WHATS_NEW_SIZE_RANGE = (1..10_000)

  ROLES_HIERARCHY = {
    'unconfirmed' => %w[all],
    'banned' => %w[all],
    'warned' => %w[all],
    'user' => %w[all user],
    'premium' => %w[all user premium],
    'primary' => %w[all user premium primary],
    'moderator' => %w[all user premium primary moderator],
    'admin' => %w[all user premium primary moderator admin],
    'dev' => AVAILABLE_FOR_ROLE
  }.freeze

  validates :v,
            uniqueness: true,
            length: { maximum: 50 },
            format: { with: /\A(?:(\d+)\.)?(?:(\d+)\.)?(\d+)\z/ },
            presence: true

  validates :link,
            presence: true,
            format: URI::DEFAULT_PARSER.make_regexp(%w[http https])

  validates :size, presence: true, numericality: { in: 1..2_147_483_647 }

  validates :for_role, presence: true, inclusion: { in: AVAILABLE_FOR_ROLE }

  validates :whats_new, presence: true, length: { in: WHATS_NEW_SIZE_RANGE }

  def self.for_user(user)
    user_is_blank = user.blank? || user.role.name.blank?
    scope = user_is_blank ? 'all' : ROLES_HIERARCHY[user.role.name.to_s]
    Version.where(for_role: scope)
  end

  def self.human_attribute_name(attribute_key_name, options = {})
    humanized_attributes = { v: 'Version' }
    humanized_attributes[attribute_key_name.to_sym] || super
  end
end
