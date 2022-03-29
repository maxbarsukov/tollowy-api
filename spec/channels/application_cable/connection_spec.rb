require 'rails_helper'

describe ApplicationCable::Connection, type: :channel do
  it 'is a Connection::Base' do
    expect(described_class.superclass).to be(ActionCable::Connection::Base)
  end
end
