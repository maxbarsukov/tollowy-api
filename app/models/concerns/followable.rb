module Followable
  extend ActiveSupport::Concern

  included do
    acts_as_followable

    # NOTE: undefine `acts_as_follower` methods, define own `counter_culture` counter for Followable
    undef_method :followers_count

    attr_writer :am_i_follow

    def am_i_follow = attributes.fetch('am_i_follow', @am_i_follow)
  end
end
