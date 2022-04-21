class Schemas::Response::Auth::SignOut401 < Schemas::Base
  def self.data
    Schemas::InvalidCredentialsError.ref
  end
end
