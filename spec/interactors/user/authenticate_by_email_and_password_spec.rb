# frozen_string_literal: true

require 'rails_helper'

describe User::AuthenticateByEmailAndPassword do
  include_context 'with interactor'

  let(:initial_context) do
    { email: '1@1.com', password: password }
  end

  let!(:user) { create :user, email: '1@1.com', password: 'password' }

  describe '.call' do
    context 'with valid credentials' do
      let(:password) { 'password' }

      it_behaves_like 'success interactor'

      it 'provides user instance' do
        interactor.run

        expect(context.user).to eq(user)
      end
    end

    context 'with invalid credentials' do
      let(:password) { 'wrong_password' }
      let(:error_data) do
        {
          title: 'Invalid credentials',
          status: 401,
          code: :unauthorized
        }
      end

      it_behaves_like 'failed interactor'
    end
  end
end
