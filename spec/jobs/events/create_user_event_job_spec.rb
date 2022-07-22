# frozen_string_literal: true

require 'rails_helper'

describe Events::CreateUserEventJob do
  let(:user_id) { 570_242 }

  context 'when user exists' do
    let!(:user) { create :user, id: user_id }

    it 'calls interactor to create event' do
      expect(User::Events::Create).to receive(:call!).with(user:, event: :user_registered, provider: nil)

      described_class.perform_now(user_id, :user_registered)
    end
  end

  context 'when user does not exist' do
    it 'raises' do
      expect { described_class.perform_now(user_id, :user_registered) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
