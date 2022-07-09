class ApplicationSerializer
  include JSONAPI::Serializer

  class << self
    alias call new

    def votable!
      meta do |post, params|
        { my_rate: params[:my_rate] || (params[:signed_in] ? post.my_rate : nil) }
      end
    end

    def followable!
      meta do |tag, params|
        am_i_follow = if params.key?(:am_i_follow)
                        params[:am_i_follow]
                      elsif params[:signed_in]
                        tag.am_i_follow
                      end
        { am_i_follow: am_i_follow }
      end
    end
  end

  delegate :[], to: :serializable_hash
end
