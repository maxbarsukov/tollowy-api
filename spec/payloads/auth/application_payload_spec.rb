# frozen_string_literal: true

require 'rails_helper'

describe ApplicationPayload do
  describe '.create' do
    it 'raises NotImplementedError' do
      expect { described_class.create({}) }.to raise_error(NotImplementedError)
    end
  end
end
