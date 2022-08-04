# frozen_string_literal: true

require 'rails_helper'

describe UserMailer, type: :mailer do
  describe '#new_ip_sign_in' do
    subject(:email) { described_class.new_ip_sign_in(user, '178.76.227.228', 'Location') }

    let(:user) { build(:user) }

    it { is_expected.to deliver_to(user.email) }

    it 'delivers IP' do
      expect(email.html).to include('178.76.227.228')
    end
  end
end
