class Voting::Payload < ApplicationPayload
  def self.create(obj)
    {
      data: {
        type: 'vote',
        meta: {
          message: "#{obj[:params][:votable_type]} successfully #{obj[:action]}d"
        }
      }
    }
  end
end
