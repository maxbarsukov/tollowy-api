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
        'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOjExMSwiZXhwIjoxNTg5MTE3NDAwLCJqdGkiOiJqdGkiLCJ0eXBlIjoiYWNjZXNzIn0'\
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
        'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOjExMSwiZXhwIjoxNTkxNzA1ODAwLCJqdGkiOiJqdGkiLCJ0eXBlIjoicmVmcmVzaCJ9'\
        '.H2pGRLhOk_929FXgU63UjFlX-nzFqB-3xLwJNNfbMXw'
      end
    end
  end
end
