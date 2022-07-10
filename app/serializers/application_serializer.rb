class ApplicationSerializer
  include JSONAPI::Serializer

  class << self
    alias call new

    def votable!
      meta do |votable|
        { my_rate: votable.my_rate }
      end
    end

    def followable!
      meta do |followable|
        { am_i_follow: followable.am_i_follow }
      end
    end
  end

  delegate :[], to: :serializable_hash
end
