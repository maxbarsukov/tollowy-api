class Comment::SetMyRate
  include Interactor

  delegate :controller, :comment, :current_user, to: :context

  def call
    comment.my_rate = my_rate
  end

  private

  def my_rate
    return nil if current_user.blank?

    vote = Vote.find_by(voter_id: current_user.id, votable_id: comment.id, votable_type: 'Comment')
    return 0 unless vote

    vote.vote_flag ? 1 : -1
  end
end
