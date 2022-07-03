# frozen_string_literal: true

require 'rails_helper'

describe Params::InvalidParameterError do
  it 'raises error with message' do
    expect { raise described_class, 'Bad params' }.to raise_error(described_class, 'Invalid parameter: Bad params')
  end
end
