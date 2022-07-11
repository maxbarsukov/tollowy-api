class User::SetAmIFollow
  include Interactor

  delegate :controller, :user, :current_user, to: :context

  def call
    user.am_i_follow = am_i_follow
  end

  private

  def am_i_follow
    return nil if current_user.blank?

    follow = Follow.find_by(follower_id: current_user.id, followable_id: user.id, followable_type: 'User')
    follow.present?
  end
end
