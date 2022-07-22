# == Schema Information
#
# Table name: follows
#
#  id              :bigint           not null, primary key
#  blocked         :boolean          default(FALSE), not null
#  followable_type :string           not null
#  follower_type   :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  followable_id   :bigint           not null
#  follower_id     :bigint           not null
#
# Indexes
#
#  fk_followables                            (followable_id,followable_type)
#  fk_follows                                (follower_id,follower_type)
#  index_follows_on_created_at               (created_at)
#  index_follows_on_followable               (followable_type,followable_id)
#  index_follows_on_followable_and_follower  (followable_id,followable_type,follower_id,follower_type) UNIQUE
#  index_follows_on_follower                 (follower_type,follower_id)
#
require 'rails_helper'

RSpec.describe Follow, type: :model do
  let(:user) { create(:user) }
  let(:user2) { create(:user) }

  describe 'validations' do
    subject { user.follow(user2) }

    it { is_expected.to validate_presence_of(:followable_type) }
    it { is_expected.to validate_presence_of(:follower_type) }
  end

  describe '#block!' do
    it 'blocks following' do
      user.follow(user2)
      follow = user.follows.first
      follow.block!
      expect(follow.blocked).to be(true)
    end
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
