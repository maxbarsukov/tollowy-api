# == Schema Information
#
# Table name: tags
#
#  id              :bigint           not null, primary key
#  followers_count :integer          default(0), not null
#  name            :string           not null
#  taggings_count  :integer          default(0)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_tags_on_name  (name) UNIQUE
#
require 'rails_helper'

RSpec.describe Tag, type: :model do
  before { travel_to Time.zone.local(2022) }

  after { travel_back }

  describe '.check_tags_size!' do
    it 'raises error if too much tags' do
      expect do
        Post.create(body: (1..30).to_a.map { |x| "#hey#{x} " }.join, user: create(:user))
      end.to raise_error(ValidationError)
    end
  end

  describe '#mark_as_updated' do
    it 'touches updated_at' do
      time = Time.current
      tag = described_class.new(name: 'hello')
      tag.send(:mark_as_updated)
      expect(tag.updated_at).to eq(time)
    end
  end
end
