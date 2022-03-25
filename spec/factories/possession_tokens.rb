# frozen_string_literal: true

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
FactoryBot.define do
  factory :possession_token do
    association :user

    value { 'token' }
  end
end
