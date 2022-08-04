# == Schema Information
#
# Table name: ip_addresses
#
#  id                 :bigint           not null, primary key
#  blocked            :boolean          default(FALSE), not null
#  ip                 :inet             not null
#  user_sign_in_count :integer          default(0), not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  user_id            :bigint
#
# Indexes
#
#  index_ip_addresses_on_blocked  (blocked) WHERE blocked
#  index_ip_addresses_on_ip       (ip) USING gist
#  index_ip_addresses_on_user_id  (user_id)
#

require 'rails_helper'

describe IpAddress, type: :model do
  it { is_expected.to validate_presence_of(:ip) }
  it { is_expected.to belong_to(:user).optional }

  describe '.get_by_ip' do
    before { IpAddress.create!(ip: '127.0.0.1') }

    it 'finds ip address' do
      expect(IpAddress.get_by_ip('127.0.0.1')).not_to be_nil
      expect(IpAddress.get_by_ip('130.0.0.10')).to be_nil
    end
  end
end
