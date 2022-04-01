require 'rails_helper'
RSpec.describe 'Rack::Attack', type: :request do
  # Include time helpers to allow use to use travel_to
  # within RSpec
  include ActiveSupport::Testing::TimeHelpers
  before do
    # Enable Rack::Attack for this test
    Rack::Attack.throttle('req/ip', limit: 10, period: 1.minute, &:ip)
    Rack::Attack.enabled = true
    Rack::Attack.reset!
  end

  after do
    # Disable Rack::Attack for future tests so it doesn't
    # interfere with the rest of our tests
    Rack::Attack.enabled = false
  end

  describe 'POST /api/v1/*' do
    it 'successful for 10 requests, then blocks the user nicely' do
      10.times do
        get '/api/v1/users'
        expect(response).to have_http_status(:ok)
      end

      get '/api/v1/users'
      expect(response.body).to include('service_unavailable')
      expect(response).to have_http_status(:too_many_requests)

      travel_to(10.minutes.from_now) do
        get '/api/v1/users'
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
