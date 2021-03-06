# frozen_string_literal: true

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
FactoryBot.define do
  factory :refresh_token do
    association :user
    token { 'token' }
    expires_at { 1.year.since }
    jti { 'jti' }

    trait :access do
      # {
      #   "sub": 111,
      #   "exp": 1589117400,
      #   "jti": "jti",
      #   "type": "access"
      # }
      token do
        'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOjExMSwiZXhwIjoxNTg5MTE3NDAwLCJqdGkiOiJqdGkiLCJ0eXBlIjoiYWNjZXNzIn0' \
          '.DRRhBjVrJfO2mxHIziPvzysQ243fbqnjhKek_9ixE74'
      end
    end

    trait :refresh do
      # {
      #   "sub": 111,
      #   "exp": 1591705800,
      #   "jti": "jti",
      #   "type": "refresh"
      # }
      token do
        'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOjExMSwiZXhwIjoxNTkxNzA1ODAwLCJqdGkiOiJqdGkiLCJ0eXBlIjoicmVmcmVzaCJ9' \
          '.H2pGRLhOk_929FXgU63UjFlX-nzFqB-3xLwJNNfbMXw'
      end
    end
  end
end
