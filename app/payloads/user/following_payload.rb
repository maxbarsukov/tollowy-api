class User::FollowingPayload < ApplicationPayload
  def self.create(obj)
    data = obj.follows.collection.map do |item|
      serializer = case item.followable_type
                   when 'User'
                     UserFollowableSerializer
                   else
                     TagFollowableSerializer
                   end
      options = { params: { followed_at: item.created_at } }
      serializer.call(item.followable, options)[:data]
    end

    {
      data: data,
      links: obj.follows.links,
      meta: obj.follows.meta
    }
  end
end
