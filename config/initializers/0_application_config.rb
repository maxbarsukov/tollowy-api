module ApplicationConfig
  def self.[](key)
    if ENV.key?(key)
      ENV[key]
    else
      Rails.logger.debug { "Unset ENV variable: #{key}." }
      nil
    end
  end
end
