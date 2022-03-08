class Events::Event < ApplicationRecord
  self.table_name = 'events'
  self.abstract_class = true

  extend Enumerize

  belongs_to :eventable, polymorphic: true

  validates :title, :event, presence: true

  scope :public_events, -> { [] }
end
