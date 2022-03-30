# frozen_string_literal: true

require 'rails_helper'

describe Events::UserEvent, type: :model do
  it { is_expected.to belong_to(:eventable) }
  it { is_expected.to validate_presence_of(:title) }

  it 'has events type' do
    expect(described_class::EVENTS)
      .to match_array(%i[
                        user_registered
                        user_logged_in
                        user_updated
                        reset_password_requested
                        user_reset_password
                      ])
  end

  it 'has public and private events scope' do
    create(:user_event, :public)
    create(:user_event, :private)
    expect(described_class.public_events.count).to be(1)
  end
end
