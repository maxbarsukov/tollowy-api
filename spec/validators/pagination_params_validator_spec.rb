# frozen_string_literal: true

require 'rails_helper'

describe PaginationParamsValidator do
  include_context 'when time is frozen'

  describe '#check_size_count!' do
    it 'returns nil if size valid' do
      validator = described_class.new(number: 1, size: 10)
      expect(validator.send(:check_size_count!)).to be_nil
    end

    it 'raises error if size invalid' do
      validator = described_class.new(number: 1, size: 1000)
      expect { validator.send(:check_size_count!) }.to raise_error(Pagination::PageSizeIsTooLargeError)
    end
  end
end
