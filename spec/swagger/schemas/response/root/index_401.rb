class Schemas::Response::Root::Index401 < Schemas::Base
  def self.data
    Schemas::UnauthorizedError.ref
  end
end
