class ReservedWords
  BASE_WORDS = %w[
    about
    account
    admin
    ads
    advertising
    analysis
    analytics
    api
    app
    post
    posts
    asset
    assets
    comment
    comments
    dashboard
    followers
    following
    follows
    getting-started
    history
    image
    images
    internal
    journal
    links
    me
    members
    membership
    new
    news
    notification_subscriptions
    notifications
    org
    orgs
    organization
    organizations
    tag
    tags
    uploads
    user
    users
    videos
    welcome
  ].freeze

  class << self
    def all
      @all || BASE_WORDS
    end

    attr_writer :all
  end
end
