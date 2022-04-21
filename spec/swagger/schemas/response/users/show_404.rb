class Schemas::Response::Users::Show404 < Schemas::Base
  def self.data
    Schemas::UserNotFoundError.ref
  end
end
