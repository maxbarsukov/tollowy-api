Rails.application.configure do
  config.middleware.insert_before ActionDispatch::Executor, Rack::Deflater
end
