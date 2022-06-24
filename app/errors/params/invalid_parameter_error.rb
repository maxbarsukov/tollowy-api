class Params::InvalidParameterError < StandardError
  def initialize(msg = nil)
    super("Invalid parameter: #{msg}")
  end
end
