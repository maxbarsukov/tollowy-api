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
class Post < ApplicationRecord
  extend Pagy::Searchkick

  include Commentable
  include Votable

  MAX_TAG_LIST_SIZE = 10

  searchkick text_middle: %i[body], language: :russian
  scope :search_import, -> { includes(:tags) }

  acts_as_taggable_on :tags
  resourcify

  belongs_to :user

  counter_culture :user

  validates :body, presence: true, length: { in: 1..10_000 }
  validates :comments_count, presence: true

  validate :validate_tag, if: :body_changed?

  before_save :update_tags_list, if: :body_changed?
  after_save :touch_tags, if: :saved_change_to_tag_list?

  def search_data
    attributes.merge(
      tags_name: tags.map(&:name).join(" ")
    ).without('id')
  end

  private

  def validate_tag
    # check there are not too many tags
    return errors.add(:tag_list, I18n.t('models.post.too_many_tags')) if tag_list.size > MAX_TAG_LIST_SIZE

    # check tags names aren't too long and don't contain non alphabet characters
    tag_list.each do |tag|
      new_tag = Tag.new(name: tag)
      new_tag.validate_name
      new_tag.errors.messages[:name].each { |message| errors.add(:tag, "\"#{tag}\" #{message}") }
    end
  end

  def update_tags_list
    tags = Tag.from_text(body)
    Tag.check_tags! tags, errors
    self.tag_list = tags
  end

  def touch_tags
    tags.touch_all(:updated_at)
  end
end
