class Auth::SignOutPayload < ApplicationPayload
  def self.create(obj)
    {
      data: {
        message: obj.message
      }
    }
  end
end
