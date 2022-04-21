class Schemas::Response::Auth::SignUp < Schemas::Base
  def self.data
    Schemas::Auth.ref
  end
end
