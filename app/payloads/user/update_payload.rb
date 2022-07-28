class User::UpdatePayload < User::ShowPayload
  def self.create(obj)
    options = {}.tap do |opt|
      opt[:meta] = { message: obj.message } if obj.message.present?
    end

    UserSerializer.call(obj.user, options)
  end
end
