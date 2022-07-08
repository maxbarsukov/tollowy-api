class Api::V1::FollowsController < Api::V1::ApiController
  before_action :authenticate_good_standing_user!,
                :validate_followable_type!,
                :validate_followable_id!,
                :set_followable

  # POST /api/v1/follow
  def follow
    fail!('Already following') if current_user.following?(@followable)
    current_user.follow @followable

    json_response Follow::Payload.create({ params: follow_params, action: 'follow' })
  end

  # DELETE /api/v1/follow
  def unfollow
    fail!('Not following') unless current_user.following?(@followable)
    current_user.stop_following @followable

    json_response Follow::Payload.create({ params: follow_params, action: 'unfollow' })
  end

  private

  def fail!(msg) = raise(FollowingError, "#{msg} #{follow_params[:followable_type]}")

  def set_followable
    followable_class = follow_params[:followable_type].constantize
    @followable = followable_class.find(follow_params[:followable_id])
  end

  def validate_followable_type!
    return if Follow::FOLLOWABLE_TYPES.include? followable_type

    raise Params::InvalidParameterError,
          "followable_type must be one of the list: #{(Follow::FOLLOWABLE_TYPES - [Tag::NAME]).join(', ')}, " \
          "passed #{follow_params[:followable_type]}"
  end

  def validate_followable_id!
    return unless followable_type == 'User' && current_user.id == follow_params[:followable_id]

    raise Params::InvalidParameterError, 'You cant follow yourself'
  end

  def followable_type
    return Tag::NAME if follow_params[:followable_type] == 'Tag'

    follow_params[:followable_type]
  end

  def follow_params
    ActionController::Parameters.new(
      { followable_type: 'User' }.merge(json_params(%i[followable_type followable_id]))
    )
  end
end
