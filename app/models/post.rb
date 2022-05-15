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
class Post < ApplicationRecord
  include Commentable

  resourcify

  belongs_to :user

  counter_culture :user

  validates :body, presence: true, length: { in: 1..10_000 }
end
