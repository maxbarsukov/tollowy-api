class Api::V1::VotesController < Api::V1::ApiController
  before_action :authenticate_good_standing_user!, :validate_votable_type!, :set_votable

  # POST /api/v1/like
  # DELETE /api/v1/like
  # POST /api/v1/dislike
  # DELETE /api/v1/dislike
  %w[like dislike].each do |verb|
    # true = POST, false = DELETE
    [true, false].freeze.each do |action|
      name = action ? verb : "un#{verb}"
      define_method(name) do
        fail!("#{action ? 'already' : 'not'} #{verb}d") if send(:"#{verb}d?").send(action ? :itself : :!)
        @votable.send(:"#{name}d_by", current_user)

        json_response Voting::Payload.create(({ params: vote_params, action: name }))
      end
    end
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
