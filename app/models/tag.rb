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
class Tag < ActsAsTaggableOn::Tag
  HASHTAG_REGEXP = /#(\w+)/i
  HEX_COLOR_REGEXP = /(?<=#)(?<!^)(\h{6}|\h{3})/

  NAME = 'ActsAsTaggableOn::Tag'.freeze

  acts_as_followable
  undef_method :followers_count

  attr_writer :am_i_follow

  def am_i_follow = attributes.fetch('am_i_follow', @am_i_follow)

  resourcify

  has_many :posts, through: :taggings, source: :taggable, source_type: 'Post'

  validates :followers_count, presence: true
  validate :validate_name

  before_save :mark_as_updated

  def validate_name
    errors.add(:name, I18n.t('errors.messages.too_long', count: 30)) if name.length > 30
    # [:alnum:] is not used here because it supports diacritical characters.
    # If we decide to allow diacritics in the future, we should replace the
    # following regex with [:alnum:].
    errors.add(:name, I18n.t('errors.messages.contains_prohibited_characters')) unless name.match?(/\A[[:alnum:]]+\z/i)
  end

  def self.from_text(body)
    (body.scan(HASHTAG_REGEXP).flatten - body.scan(HEX_COLOR_REGEXP).flatten).uniq
  end

  def self.check_tags!(tags, errors)
    check_tags_size!(tags, errors)
    check_tags_names!(tags, errors)
  end

  private

  def mark_as_updated
    # Acts-as-taggable didn't come with this by default
    self.updated_at = Time.current
  end

  class << self
    def check_tags_size!(tags, errors)
      return unless tags.size > Post::MAX_TAG_LIST_SIZE

      errors.add(:tag_list, I18n.t('models.post.too_many_tags'))
      raise ValidationError, errors.full_messages.to_sentence
    end

    def check_tags_names!(tags, errors)
      tags.each do |tag|
        new_tag = Tag.new(name: tag)
        new_tag.validate_name
        new_tag.errors.messages[:name].each { |message| errors.add(:tag, "\"#{tag}\" #{message}") }
      end
      raise ValidationError, errors.full_messages.to_sentence if errors.present?
    end
  end
end
