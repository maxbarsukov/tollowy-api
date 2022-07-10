module Votable
  extend ActiveSupport::Concern

  included do
    acts_as_votable

    alias_attribute :likes_count, :cached_votes_up
    alias_attribute :dislikes_count, :cached_votes_down
    alias_attribute :score, :cached_votes_score

    attr_writer :my_rate

    def my_rate = attributes.fetch('my_rate', @my_rate)
  end
end
