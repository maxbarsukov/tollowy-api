# frozen_string_literal: true

shared_context 'when time is frozen' do
  let(:current_time) { Time.zone.local(2022, 2, 13, 12, 0o0) }

  before { travel_to(current_time) }
end
