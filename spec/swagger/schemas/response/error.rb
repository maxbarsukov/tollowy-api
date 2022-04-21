class Schemas::Response::Error < Schemas::Base
  def self.data = Schemas::Error.ref
end
