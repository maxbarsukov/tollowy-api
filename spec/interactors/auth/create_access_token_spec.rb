# frozen_string_literal: true

require 'rails_helper'

describe Auth::CreateAccessToken do
  include_context 'with interactor'
  include_context 'when time is frozen'

  let(:initial_context) { { user:, token_payload: } }
  let(:user) { create :user, id: 111_111 }

  describe '.call' do
    context 'with existing jti' do
      let(:token_payload) { { jti: 'existing_token_jti' } }
      let(:expected_jti) { 'existing_token_jti' }
      let(:expected_token_payload) do
        {
          'sub' => 111_111,
          # "exp" => 1_589_117_400,
          'exp' => 1_644_757_200,
          'jti' => 'existing_token_jti',
          'type' => 'access'
        }
      end

      it_behaves_like 'success interactor'

      it 'provides previous token jti' do
        interactor.run

        expect(context.jti).to eq(expected_jti)
      end

      it 'generates access token with correct payload' do
        interactor.run

        expect(context.access_token).to have_jwt_token_payload(expected_token_payload)
      end
    end

    context 'with generate jti' do
      let(:token_payload) { {} }
      let(:expected_jti) { 'b37ea66fcbdb61cb4793cd98c9489c96' }
      let(:expected_token_payload) do
        {
          'sub' => 111_111,
          'exp' => 1_644_757_200,
          'jti' => 'b37ea66fcbdb61cb4793cd98c9489c96',
          'type' => 'access'
        }
      end

      it_behaves_like 'success interactor'

      it 'generates new access token jti' do
        interactor.run

        expect(context.jti).to eq(expected_jti)
      end

      it 'generates access token with correct payload' do
        interactor.run

        expect(context.access_token).to have_jwt_token_payload(expected_token_payload)
      end
    end
  end
end
