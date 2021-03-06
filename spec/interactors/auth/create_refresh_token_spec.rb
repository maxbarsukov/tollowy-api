require 'rails_helper'

describe Auth::CreateRefreshToken do
  include_context 'with interactor'
  include_context 'when time is frozen'

  before do
    ENV['JWT_SECRET_TOKEN'] = 'token'
  end

  let(:initial_context) { { user:, jti: } }

  let(:user) { create :user, id: 111_111 }
  let(:refresh_token) do
    'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOjExMTExMSwiZXhwIjoxNjQ3MzQ1NjAwLCJqdGkiOiJqdGkiLCJ0eXBlIjoicmVmcmVzaCJ9.' \
      'SjJ81yxqC-lXi2GyMaUNo6EsIFjXGFTnLCNIm5iWaaA'
  end
  let(:saved_refresh_token) { RefreshToken.last }
  let(:jti) { 'jti' }
  let(:expires_at) { 30.days.since }

  let(:refresh_token_attributes) do
    {
      user_id: 111_111,
      token: refresh_token,
      jti:,
      expires_at:
    }
  end

  describe '.call' do
    it_behaves_like 'success interactor'

    it 'provides generated refresh token' do
      interactor.run

      expect(context.refresh_token).to eq(refresh_token)
    end

    it 'creates refresh token' do
      interactor.run

      expect(RefreshToken.count).to eq(1)
      expect(saved_refresh_token).to have_attributes(refresh_token_attributes)
    end
  end
end
