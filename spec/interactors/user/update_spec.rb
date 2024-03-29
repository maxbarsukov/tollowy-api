# frozen_string_literal: true

require 'rails_helper'

describe User::Update do
  describe '.call' do
    include_context 'with interactor'

    let(:user) { create :user, password: 'Qq123456' }
    let(:initial_context) { { user:, user_params:, current_user: user } }

    context 'with valid data' do
      let(:user_params) { { email: '1@1.com', username: 'first' } }
      let(:user_id) { user.id }
      let(:event) { :user_updated }

      it_behaves_like 'success interactor'

      it 'updates user' do
        interactor.run

        expect(user).to have_attributes(
          email: '1@1.com',
          username: 'first'
        )
      end

      it_behaves_like 'event source'
    end

    context 'when updating password' do
      let(:user_params) { { current_password: 'Qq123456', password: 'QQqwerty1' } }

      it_behaves_like 'success interactor'

      it 'updates password' do
        interactor.run

        expect(user.authenticate('QQqwerty1')).to be_truthy
      end
    end

    context 'when no old password provided' do
      let(:user_params) { { password: 'QQqwerty1' } }
      let(:error_data) do
        {
          status: '422',
          code: :unprocessable_entity,
          title: 'Record Invalid',
          detail: ['Current password is incorrect', "Current password can't be blank"]
        }
      end

      it_behaves_like 'failed interactor'
    end

    context 'when wrong old password provided' do
      let(:user_params) { { current_password: 'Qq__3456', password: 'qwerty' } }
      let(:error_data) do
        {
          status: '422',
          code: :unprocessable_entity,
          title: 'Record Invalid',
          detail: ['Current password is incorrect']
        }
      end

      it_behaves_like 'failed interactor'
    end
  end
end
