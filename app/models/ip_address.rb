# == Schema Information
#
# Table name: ip_addresses
#
#  id                 :bigint           not null, primary key
#  blocked            :boolean          default(FALSE), not null
#  ip                 :inet             not null
#  user_sign_in_count :integer          default(0), not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  user_id            :bigint
#
# Indexes
#
#  index_ip_addresses_on_blocked  (blocked) WHERE blocked
#  index_ip_addresses_on_ip       (ip) USING gist
#  index_ip_addresses_on_user_id  (user_id)
#
class IpAddress < ApplicationRecord
  belongs_to :user, optional: true

  scope :blocked, -> { where('blocked') }

  validates :ip, ip: true, presence: true
  validates :blocked, inclusion: { in: [true, false] }
  validates :user_sign_in_count,
            presence: true,
            allow_nil: true,
            numericality: { only_integer: true }

  def get_by_ip(ip)
    IpAddress.find_by(['ip >>= inet ?', ip])
  end
end
