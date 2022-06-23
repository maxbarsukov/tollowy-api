# TODO
class Api::V1::VotesController < Api::V1::ApiController
  before_action :authenticate_good_standing_user!

  # POST /api/v1/like
  def like; end

  # DELETE /api/v1/like
  def unlike; end

  # POST /api/v1/dislike
  def dislike; end

  # DELETE /api/v1/dislike
  def undislike; end

  private

  def vote_params
    { data: { attributes: { voteable_type: 'Post' } } }
      .merge(json_params(%i[voteable_type voteable_id]))
  end
end
