# frozen_string_literal: true

require 'rails_helper'

describe ApplicationConfig do
  describe '.[]' do
    context 'when ENV var unset' do
      it 'returns nil' do
        expect(described_class['UNSET']).to be_nil
      end
    end

    context 'when ENV var set' do
      ENV['VAR'] = 'var'

      it 'returns variable' do
        expect(described_class['VAR']).to eq 'var'
      end

      it 'dont logs anything' do
        allow(Rails.logger).to receive(:debug)
        expect(Rails.logger).not_to receive(:debug).with(anything)
      end
    end
  end
end
