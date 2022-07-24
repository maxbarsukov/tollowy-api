class Auth::ProviderPayload < Auth::AuthPayload
  def self.create(obj)
    {
      data: {
        **Auth::AuthPayload.create(obj)[:data],
        meta: { message: obj.message }
      }
    }
  end
end
