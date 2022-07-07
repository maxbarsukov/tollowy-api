class Follow::Payload < ApplicationPayload
  def self.create(obj)
    {
      data: {
        type: 'follow',
        meta: {
          message: "#{obj[:params][:followable_type]} successfully #{obj[:action]}ed"
        }
      }
    }
  end
end
