class Comment::Show
  include Interactor

  delegate :current_user, :comment, to: :context

  def call
    if current_user.blank?
      context.my_rate = nil
      return
    end

    vote = Vote.find_by(voter_id: current_user.id, votable_id: comment.id, votable_type: 'Comment')

    context.my_rate = 0 unless vote
    context.my_rate ||= vote.vote_flag ? 1 : -1
  end
end
