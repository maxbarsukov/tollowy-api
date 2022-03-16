class Events::Event < ApplicationRecord
  extend Enumerize

  belongs_to :eventable, polymorphic: true

  validates :title, :event, presence: true

  scope :public_events, -> { [] }
end
