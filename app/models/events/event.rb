# == Schema Information
#
# Table name: events
#
#  id             :bigint           not null, primary key
#  event          :string           not null
#  eventable_type :string           not null
#  title          :string           not null
#  type           :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  eventable_id   :bigint           not null
#
# Indexes
#
#  index_events_on_eventable  (eventable_type,eventable_id)
#
class Events::Event < ApplicationRecord
  extend Enumerize

  belongs_to :eventable, polymorphic: true

  validates :title, :event, :eventable_type, presence: true

  scope :public_events, -> { [] }
end
