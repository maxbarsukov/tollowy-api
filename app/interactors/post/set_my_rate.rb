class Post::SetMyRate
  include Interactor

  delegate :controller, :post, :current_user, to: :context

  def call
    post.my_rate = my_rate
  end

  private

  def my_rate
    return nil if current_user.blank?

    vote = Vote.find_by(voter_id: current_user.id, votable_id: post.id, votable_type: 'Post')
    return 0 unless vote

    vote.vote_flag ? 1 : -1
  end
end
