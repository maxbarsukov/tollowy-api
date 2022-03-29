require 'rails_helper'

describe ApplicationCable::Channel, type: :channel do
  it 'is a Channel::Base' do
    expect(described_class.superclass).to be(ActionCable::Channel::Base)
  end
end
