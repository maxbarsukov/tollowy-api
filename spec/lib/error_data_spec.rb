require 'rails_helper'

describe ErrorData do
  describe '#initialize' do
    it 'raises error with bad detail type' do
      expect { described_class.new(detail: 1) }.to raise_error(RuntimeError)
    end
  end
end
