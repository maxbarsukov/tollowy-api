# frozen_string_literal: true

require 'rails_helper'

describe User::Create do
  include_context 'with interactor'

  let(:initial_context) { { user_params: } }

  describe '.call' do
    context 'with valid data' do
      let(:user_params) do
        { email: 'user@example.com', password: 'Password1', username: 'username' }
      end

      it_behaves_like 'success interactor'

      it 'creates user' do
        interactor.run

        expect(context.user).to be_persisted
        expect(context.user).to have_attributes(
          email: 'user@example.com',
          password: 'Password1',
          username: 'username'
        )
      end

      it 'assigns default role' do
        interactor.run

        expect(context.user.has_role?(:user)).to be false
        expect(context.user.has_role?(:unconfirmed)).to be true
      end
    end

    context 'with invalid data' do
      let(:user_params) do
        { email: 'user', password: '' }
      end
      let(:error_data) do
        {
          status: '422',
          code: :unprocessable_entity,
          title: 'Record Invalid',
          detail: [
            'Email is invalid',
            'Username is invalid',
            "Username can't be blank",
            "Password digest can't be blank",
            "Password can't be blank"
          ]
        }
      end

      it_behaves_like 'failed interactor'
    end
  end
end
