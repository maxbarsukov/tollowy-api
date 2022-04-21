class Schemas::Response::Auth::SignIn < Schemas::Base
  def self.data
    Schemas::Auth.ref
  end
end
