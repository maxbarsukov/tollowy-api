# == Schema Information
#
# Table name: versions
#
#  id         :bigint           not null, primary key
#  for_role   :string           default("all"), not null
#  link       :string           not null
#  size       :integer          not null
#  v          :string           not null
#  whats_new  :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_versions_on_v  (v) UNIQUE
#
require 'rails_helper'

describe Version, type: :model do
  it { is_expected.to validate_presence_of(:v) }
  it { is_expected.to validate_presence_of(:link) }
  it { is_expected.to validate_presence_of(:whats_new) }
  it { is_expected.to validate_presence_of(:for_role) }
  it { is_expected.to validate_presence_of(:size) }

  describe '.for_user' do
    before do
      create_list(:version, 3)
      create(:version, for_role: 'user')
      create(:version, for_role: 'moderator')
      create(:version, for_role: 'admin')
      create(:version, for_role: 'dev')
    end

    it 'returns versions for `all` if user is nil' do
      expect(described_class.for_user(nil).count).to eq(3)
    end

    it 'returns user + all versions for user' do
      user = create(:user, :with_user_role)
      expect(described_class.for_user(user).count).to eq(4)
    end

    it 'returns all except dev versions for admin' do
      user = create(:user, :with_admin_role)
      expect(described_class.for_user(user).count).to eq(6)
    end

    it 'returns all versions for dev' do
      user = create(:user, :with_dev_role)
      expect(described_class.for_user(user).count).to eq(described_class.count)
    end
  end
end
