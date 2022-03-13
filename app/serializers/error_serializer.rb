class ErrorSerializer
  def self.call(errors)
    return { errors: [] } if errors.empty?

    json = {}
    json[:errors] = errors.map do |error|
      error[:code] ||= :unprocessable_entity
      error[:status] ||= error[:code] ? Rack::Utils.status_code(code).to_s : '422'
      error
    end

    json
  end
end
