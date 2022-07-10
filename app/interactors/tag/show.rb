class Tag::Show
  include Interactor

  delegate :controller, :tag, :current_user, to: :context

  def call
    tag.am_i_follow = am_i_follow
  end

  private

  def am_i_follow
    return nil if current_user.blank?

    follow = Follow.find_by(follower_id: current_user.id, followable_id: tag.id, followable_type: Tag::NAME)
    follow.present?
  end
end
