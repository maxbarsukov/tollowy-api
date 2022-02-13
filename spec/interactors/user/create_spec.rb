# frozen_string_literal: true

require 'rails_helper'

describe User::Create do
  include_context 'with interactor'

  let(:initial_context) { { user_params: user_params } }

  describe '.call' do
    context 'with valid data' do
      let(:user_params) do
        { email: 'user@example.com', password: 'password', username: 'username' }
      end

      it_behaves_like 'success interactor'

      it 'creates user' do
        interactor.run

        expect(context.user).to be_persisted
        expect(context.user).to have_attributes(
          email: 'user@example.com',
          password: 'password',
          username: 'username'
        )
      end
    end

    context 'with invalid data' do
      let(:user_params) do
        { email: 'user', password: '' }
      end
      let(:error_data) do
        { message: 'Record Invalid', detail: ["Password can't be blank", 'Email is invalid'] }
      end

      it_behaves_like 'failed interactor'
    end
  end
end
