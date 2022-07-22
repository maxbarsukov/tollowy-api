# == Schema Information
#
# Table name: posts
#
#  id                      :bigint           not null, primary key
#  body                    :text             not null
#  cached_votes_down       :integer          default(0)
#  cached_votes_score      :integer          default(0)
#  cached_votes_total      :integer          default(0)
#  cached_votes_up         :integer          default(0)
#  cached_weighted_average :float            default(0.0)
#  cached_weighted_score   :integer          default(0)
#  cached_weighted_total   :integer          default(0)
#  comments_count          :integer          default(0), not null
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  user_id                 :bigint           not null
#
# Indexes
#
#  index_posts_on_user_id  (user_id)
#
require 'rails_helper'

RSpec.describe Post, type: :model do
  it { is_expected.to validate_presence_of(:body) }
  it { is_expected.to validate_length_of(:body).is_at_least(1).is_at_most(10_000) }

  it { is_expected.to belong_to(:user) }

  describe '#touch_tags' do
    before { travel_to Time.zone.local(2022) }

    after { travel_back }

    it 'touches tags updated_at' do
      time = Time.current
      post = described_class.create(body: (1..10).to_a.map { |x| "#hey#{x} " }.join, user: create(:user))
      post.send(:touch_tags)
      post.tags.each do |tag|
        expect(tag.updated_at).to eq(time)
      end
    end
  end
end
