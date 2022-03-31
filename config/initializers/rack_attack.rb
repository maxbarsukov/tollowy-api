class Rack::Attack
  Rack::Attack.cache.store = ActiveSupport::Cache::RedisCacheStore.new(url: ENV['REDIS_URL'])

  # Key: "rack::attack:#{Time.now.to_i/:period}:req/ip:#{req.ip}"
  throttle('req/ip', limit: 10, period: 1.second, &:ip)

  # Key: "rack::attack:#{Time.now.to_i/:period}:logins/ip:#{req.ip}"
  throttle('logins/ip', limit: 5, period: 1.second) do |req|
    req.ip if req.path.include?('auth') && req.post?
  end

  self.throttled_responder = lambda do |_env|
    [
      429,
      { 'Content-Type' => 'application/json' },
      [
        {
          errors:
            [{
              code: 'service_unavailable',
              status: '429',
              title: 'You are sending too many requests'
            }]
        }.to_json
      ]
    ]
  end
end

Rack::Attack.enabled = Rails.env.production? && ENV['DISABLE_RACK_ATTACK'] != 'true'
