require 'rails_helper'

describe UserDecorator do
  it 'is expected to inherit Draper::Decorator' do
    expect(described_class).to be < Draper::Decorator
  end
end
