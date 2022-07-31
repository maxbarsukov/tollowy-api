# frozen_string_literal: true

require 'rails_helper'

describe AuthMailer, type: :mailer do
  describe '#password_recovery' do
    subject(:email) { described_class.password_recovery(user) }

    let(:user) { build(:user, password_reset_token: '1234') }

    it { is_expected.to deliver_to(user.email) }

    it 'delivers the token' do
      expect(email.html).to include(user.password_reset_token)
    end
  end

  describe '#confirm_user' do
    context 'with new user' do
      subject(:email) { described_class.confirm_user(possession_token, new_user: true) }

      let!(:user) { create(:user) }
      let(:possession_token) { user.possession_tokens.create!(value: '123456') }

      it { is_expected.to deliver_to(user.email) }

      it 'delivers with welcome subject' do
        expect(email.subject).to eq("#{I18n.t('mailers.auth.welcome.title')} | Followy")
      end

      it 'delivers the possession_token' do
        expect(email.html).to include(possession_token.value)
      end

      it 'renders body' do
        expect(email.html).to include("Здравствуйте, <b style=\"color:#000000\">#{user.username}</b>!")
        expect(email.html).to include('Мы рады, что вы зарегистрировались в Followy')
        expect(email.html).to include('только что зарегистрировали новую учетную запись')
      end
    end

    context 'without new user' do
      subject(:email) { described_class.confirm_user(possession_token) }

      let!(:user) { create(:user) }
      let(:possession_token) { user.possession_tokens.create!(value: '123456') }

      it { is_expected.to deliver_to(user.email) }

      it 'delivers with welcome subject' do
        expect(email.subject).to eq("#{I18n.t('mailers.auth.confirm_user.title')} | Followy")
      end

      it 'delivers the possession_token' do
        expect(email.html).to include(possession_token.value)
      end

      it 'renders body' do
        expect(email.html).to include("Здравствуйте, <b style=\"color:#000000\">#{user.username}</b>!")
        expect(email.html).to include('Подтверждение аккаунта')
        expect(email.html).to include('для вашей учетной записи запрошено подтверждение')
        expect(email.html).to include('8 часов')
      end
    end
  end
end
