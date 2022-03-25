# == Schema Information
#
# Table name: refresh_tokens
#
#  id         :bigint           not null, primary key
#  expires_at :datetime         not null
#  jti        :string
#  token      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_refresh_tokens_on_jti      (jti)
#  index_refresh_tokens_on_token    (token)
#  index_refresh_tokens_on_user_id  (user_id)
#
class RefreshToken < ApplicationRecord
  belongs_to :user

  validates :token, :expires_at, presence: true

  scope :active, -> { where('expires_at >= ?', Time.current) }
end
