# frozen_string_literal: true

require 'rails_helper'

describe Events::Event, type: :model do
  it { is_expected.to belong_to(:eventable) }
  it { is_expected.to validate_presence_of(:title) }

  it 'has empty public events scope' do
    create(:user_event)
    expect(described_class.public_events.count).to be(0)
  end
end
