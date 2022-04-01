class Auth::ConfirmPayload < Auth::AuthPayload
  def self.create(obj)
    auth_data(
      attr: {
        me: UserSerializer.call(obj.user)[:data]
      }
    )
  end
end
