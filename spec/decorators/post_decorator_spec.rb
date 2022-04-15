require 'rails_helper'

describe PostDecorator do
  it 'is expected to inherit Draper::Decorator' do
    expect(described_class).to be < Draper::Decorator
  end
end
