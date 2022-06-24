class Post::Show
  include Interactor

  delegate :current_user, :post, to: :context

  def call
    if current_user.present?
      vote = Vote.find_by(voter_id: current_user.id, votable_id: post.id, votable_type: 'Post')

      context.my_rate = 0 unless vote
      context.my_rate ||= vote.vote_flag ? 1 : -1
    else
      context.my_rate = nil
    end
  end
end
