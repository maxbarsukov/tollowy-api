class Api::V1::VotesController < Api::V1::ApiController
  before_action :authenticate_good_standing_user!, :validate_votable_type!, :set_votable

  # POST /api/v1/like
  def like
    fail!('already liked') if liked?
    @votable.liked_by current_user

    json_response Voting::Payload.create({ params: vote_params, action: 'like' })
  end

  # DELETE /api/v1/like
  def unlike
    fail!('not liked') unless liked?
    @votable.unliked_by current_user

    json_response Voting::Payload.create({ params: vote_params, action: 'unlike' })
  end

  # POST /api/v1/dislike
  def dislike
    fail!('already disliked') if disliked?
    @votable.disliked_by current_user

    json_response Voting::Payload.create({ params: vote_params, action: 'dislike' })
  end

  # DELETE /api/v1/dislike
  def undislike
    fail!('not disliked') unless disliked?
    @votable.undisliked_by current_user

    json_response Voting::Payload.create({ params: vote_params, action: 'undislike' })
  end

  private

  def fail!(msg) = raise(VotingError, "#{vote_params[:votable_type]} #{msg}")

  def liked? = current_user.liked?(@votable)

  def disliked? = current_user.disliked?(@votable)

  def set_votable
    @votable = Post.find(vote_params[:votable_id])
  end

  def validate_votable_type!
    return if Vote::VOTABLE_TYPES.include? vote_params[:votable_type]

    raise Params::InvalidParameterError,
          "votable_type must be one of the list: #{Vote::VOTABLE_TYPES}, passed #{vote_params[:votable_type]}"
  end

  def vote_params
    ActionController::Parameters.new(
      { votable_type: 'Post' }.merge(json_params(%i[votable_type votable_id]))
    )
  end
end
