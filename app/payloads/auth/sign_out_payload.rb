class Auth::SignOutPayload < Auth::AuthPayload
  def self.create(obj)
    auth_data(
      meta: {
        message: obj.message
      }
    )
  end
end
