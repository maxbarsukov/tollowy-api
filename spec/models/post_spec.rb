# == Schema Information
#
# Table name: posts
#
#  id             :bigint           not null, primary key
#  body           :text             not null
#  comments_count :integer          default(0), not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  user_id        :bigint           not null
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
end
