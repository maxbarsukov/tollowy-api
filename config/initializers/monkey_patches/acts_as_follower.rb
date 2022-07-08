module ActsAsFollower::Follower::InstanceMethods
  def following_by_type(followable_type, options = {})
    model = options.fetch(:model, followable_type.constantize)
    followables = model
                  .joins(:followings)
                  .where('follows.blocked' => false,
                         'follows.follower_id' => id,
                         'follows.follower_type' => parent_class_name(self),
                         'follows.followable_type' => followable_type)
    followables = followables.limit(options[:limit]) if options.key?(:limit)
    followables = followables.includes(options[:includes]) if options.key?(:includes)
    followables
  end
end
