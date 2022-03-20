# frozen_string_literal: true

class ApplicationPolicy
  attr_reader :user, :record, :error_message

  # @param user [Object] the "user"  we're attempting to authorize.
  # @return [TrueClass] if we have a "user" (whatever that object might be, we'll assume the callers
  #         know what they're doing) and that user is not suspended
  #
  # @raise [ApplicationPolicy::UserSuspendedError] if our user suspended
  # @raise [ApplicationPolicy::UserRequiredError] if our given user was "falsey"
  #
  # @see {ApplicationPolicy.require_user!}
  def self.require_user_in_good_standing!(user:)
    require_user!(user: user)

    return true unless user.suspended?

    raise Auth::UserSuspendedError, I18n.t('policies.application_policy.your_account_is_suspended')
  end

  # @param user [Object] the "user" we're attempting to authorize.
  # @return [TrueClass] if we have a "user" (whatever that object might be, we'll assume the callers
  #         know what they're doing)
  #
  # @raise [ApplicationPolicy::UserRequiredError] if our user is "falsey"
  def self.require_user!(user:)
    return true if user

    raise Auth::UserRequiredError, I18n.t('policies.application_policy.you_must_be_logged_in')
  end

  # @param user [User] who's the one taking the action?
  #
  # @param record [Class, Object] what is the user acting on?  This could be a model (e.g. Article)
  #        or an instance of a model (e.g. Article.new) or any Plain Old Ruby Object [PORO].
  def initialize(user, record)
    @user = user
    @record = record
    @error_message = nil

    require_user!
  end

  def index?
    false
  end

  def show?
    false
  end

  def create?
    false
  end

  def new?
    create?
  end

  def update?
    false
  end

  def edit?
    update?
  end

  def destroy?
    false
  end

  def scope
    Pundit.policy_scope!(user, record.class)
  end

  class Scope
    def initialize(user, scope)
      @user = user
      @scope = scope

      require_user!
    end

    def resolve
      scope.all
    end

    private

    attr_reader :user, :scope
  end

  protected

  def require_user!
    self.class.require_user!(user: user)
  end

  def require_user_in_good_standing!
    self.class.require_user_in_good_standing!(user: user)
  end
end
