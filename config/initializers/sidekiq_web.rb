Sidekiq::Web.use ActionDispatch::Cookies
Sidekiq::Web.use ActionDispatch::Session::CookieStore, key: '_interslice_session'

Sidekiq::Web.register SidekiqWebAdmin
Sidekiq::Web.tabs['Admin'] = 'admin'
