class Rack::Attack
  class Request < ::Rack::Request
    def remote_ip
      @remote_ip ||= (env['action_dispatch.remote_ip'] || ip).to_s
    end
  end

  Rack::Attack.cache.store = ActiveSupport::Cache::RedisCacheStore.new(url: ENV.fetch('REDIS_URL', nil))

  # Key: "rack::attack:#{Time.now.to_i/:period}:req/ip:#{req.ip}"
  throttle('req/ip', limit: 10, period: 1.second, &:ip)

  # Key: "rack::attack:#{Time.now.to_i/:period}:logins/ip:#{req.ip}"
  throttle('logins/ip', limit: 5, period: 1.second) do |req|
    req.ip if req.path.include?('auth') && req.post?
  end

  if ENV['FULL_IP_BAN'] == 'true'
    blocklist 'blocked/ip' do |req|
      IpAddress.exists?(['ip >>= inet ? AND blocked', req.remote_ip])
    end
  end

  # Block suspicious requests for '/etc/password' or wordpress specific paths.
  # After 3 blocked requests in 10 minutes, block all requests from that IP for 5 minutes.
  blocklist('fail2ban pentesters') do |req|
    # `filter` returns truthy value if request fails, or if it's from a previously banned IP
    # so the request is blocked
    Rack::Attack::Fail2Ban.filter(
      "pentesters-#{req.ip}", maxretry: 3, findtime: 10.minutes, bantime: 5.minutes
    ) do
      # The count for the IP is incremented if the return value is truthy
      CGI.unescape(req.query_string).include?('/etc/passwd') || req.path.include?('/etc/passwd')
    end
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

  # Using 503 because it may make attacker think that they have successfully
  # DOSed the site. Rack::Attack returns 403 for blocklists by default
  self.blocklisted_responder = lambda do |_env|
    [
      503,
      { 'Content-Type' => 'application/json' },
      [
        {
          errors:
            [{
              code: 'service_unavailable',
              status: '503',
              title: 'Your IP is on the banned list'
            }]
        }.to_json
      ]
    ]
  end
end

Rack::Attack.enabled = (ENV['FORCE_RACK_ATTACK'] == 'true') ||
                       (Rails.env.production? && ENV['DISABLE_RACK_ATTACK'] != 'true')
