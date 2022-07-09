class LikedVotableQuery
  attr_reader :votable, :model, :current_user_id

  def initialize(votable, model, current_user)
    @votable = votable
    @model = model
    @current_user_id = current_user.id
  end

  def call
    table = model.table_name
    votable
      .joins(
        model.sanitize_sql_array(
          [
            "JOIN users ON users.id = ? LEFT JOIN votes ON votes.votable_id = #{table}.id " \
            'AND votes.voter_id = ? AND votes.votable_type = ?',
            current_user_id, current_user_id, model.name
          ]
        )
      )
      .select(
        "\"#{table}\".* AS #{table}_data, " \
        'CASE votes.vote_flag WHEN TRUE THEN 1 WHEN FALSE THEN -1 ELSE 0 END AS my_rate'
      )
      .group("my_rate, #{table}.id")
  end
end
