class ErrorSerializer
  def self.call(errors)
    return { errors: [] } if errors.empty?

    { errors: }
  end
end
