class FollowingByCurrentUserQuery
  attr_reader :followable, :model, :current_user_id, :followable_type

  def initialize(followable, model, current_user, followable_type = nil)
    @followable = followable
    @model = model
    @current_user_id = current_user.id
    @followable_type = followable_type || model.name
  end

  def call
    table = model.table_name
    followable
      .joins(
        model.sanitize_sql_array(
          [
            "JOIN users ON users.id = ? LEFT JOIN follows ON follows.followable_id = #{table}.id " \
            'AND follows.follower_id = ? AND follows.blocked = FALSE AND follows.followable_type = ?',
            current_user_id, current_user_id, followable_type
          ]
        )
      )
      .select(
        "\"#{table}\".* AS #{table}_data, follows.id IS NOT NULL AS am_i_follow"
      )
      .group("am_i_follow, #{table}.id")
  end
end
