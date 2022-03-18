class Auth::SignOutPayload < ApplicationPayload
  def self.create(obj)
    {
      message: obj.message
    }
  end
end
