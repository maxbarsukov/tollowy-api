# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User update after Sign Up', type: :request do
  it 'successfully resends confmation mails and does not erase role' do
    post '/api/v1/auth/sign_up', params: {
      data: {
        type: 'auth',
        attributes: { email: 'MySUperMail@mail.com', username: 'MySUperName', password: 'MySUperPassword1' }
      }
    }
    expect(response).to have_http_status(:created)

    user_id = JSON.parse(response.body)['data']['attributes']['me']['id']
    expect(JSON.parse(response.body)['data']['attributes']['me']['attributes']['role']['name']).to eq('unconfirmed')

    user = User.find(user_id)
    result = {}
    5.times do |i|
      result = User::Update.call(current_user: user, user:, user_params: { email: "MyNew#{i}SUperMail@mail.com" })
    end

    value = result.possession_token.value
    get "/api/v1/auth/confirm?confirmation_token=#{value}"
    expect(response).to have_http_status(:ok)

    user = User.find(user_id)
    expect(user.role.name).to eq('user')
  end
end
