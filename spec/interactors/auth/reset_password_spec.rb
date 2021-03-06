# frozen_string_literal: true

require 'rails_helper'

describe Auth::ResetPassword do
  include_context 'with interactor'

  let(:user) { create(:user, :with_reset_token) }
  let(:initial_context) { { password: 'Qq123456', reset_token: } }

  context 'when token valid' do
    let(:reset_token) { user.password_reset_token }
    let(:user_id) { user.id }
    let(:event) { :user_reset_password }

    it_behaves_like 'success interactor'

    it 'clears password_reset_* attributes' do
      interactor.run

      expect(user.reload).to have_attributes(
        password_reset_token: nil,
        password_reset_sent_at: nil
      )
    end

    it_behaves_like 'event source'
  end

  context 'when token is wrong' do
    let(:reset_token) { 'wrong-token' }
    let(:error_data) do
      {
        status: '401',
        code: :unauthorized,
        title: 'Invalid credentials'
      }
    end

    it_behaves_like 'failed interactor'
  end

  context 'when token has expired' do
    let(:expiration_time) { user.password_reset_sent_at + 15.minutes + 1 }
    let(:reset_token) { user.password_reset_token }
    let(:error_data) do
      {
        status: '422',
        code: :unprocessable_entity,
        title: 'Record Invalid',
        detail: ['Password reset sent at has expired']
      }
    end

    before do
      travel_to expiration_time
      freeze_time
    end

    it_behaves_like 'failed interactor'
  end
end
