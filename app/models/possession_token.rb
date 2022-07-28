# == Schema Information
#
# Table name: possession_tokens
#
#  id         :bigint           not null, primary key
#  value      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_possession_tokens_on_user_id  (user_id)
#  index_possession_tokens_on_value    (value) UNIQUE
#
class PossessionToken < ApplicationRecord
  USER_CONFIRMATION_TTL = 8.hours

  belongs_to :user

  validates :value, presence: true, uniqueness: true

  def expired?
    USER_CONFIRMATION_TTL.since(created_at).past?
  end
end
