# frozen_string_literal: true

require 'rails_helper'

describe FilteredEventsQuery do
  subject(:query) { described_class.new(Events::UserEvent.all, filter_params) }

  let!(:event1) { create :user_event }
  let!(:event2) { create :user_event, event: :user_updated }

  let(:filter_params) { {} }

  describe '#all' do
    subject(:all) { query.all }

    it 'is expected to contain both events' do
      expect(all).to match_array([event1, event2])
    end

    context 'when param is user_updated' do
      let(:filter_params) { { events: [:user_updated] } }

      it 'is expected to contain exactly only one event' do
        expect(all).to match_array([event2])
      end
    end

    context 'when param is empty' do
      let(:filter_params) { { events: [] } }

      it { is_expected.to be_empty }
    end
  end
end
