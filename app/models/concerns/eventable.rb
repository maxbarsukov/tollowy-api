module Eventable
  extend ActiveSupport::Concern

  included do
    def self.events_class(klass)
      has_many :events, as: :eventable, dependent: :destroy, class_name: klass.to_s
    end
  end
end
