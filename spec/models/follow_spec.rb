require 'rails_helper'

RSpec.describe Follow, type: :model do
  let(:user) { create(:user) }
  let(:user2) { create(:user) }

  describe 'validations' do
    subject { user.follow(user2) }

    it { is_expected.to validate_presence_of(:followable_type) }
    it { is_expected.to validate_presence_of(:follower_type) }
  end

  it 'follows user' do
    user.follow(user2)
    expect(user.following?(user2)).to be(true)
  end

  context 'when creating and inline' do
    it 'touches the follower user while creating' do
      timestamp = 1.day.ago
      user.update_columns(updated_at: timestamp, last_followed_at: timestamp)
      described_class.create!(follower: user, followable: user2)

      user.reload
      expect(user.updated_at).to be > timestamp
      expect(user.last_followed_at).to be > timestamp
    end
  end
end
