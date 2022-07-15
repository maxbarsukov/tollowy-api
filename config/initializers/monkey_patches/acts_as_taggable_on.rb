class ActsAsTaggableOn::Tagging
  belongs_to :tagger, polymorphic: true, optional: true

  after_save :reindex_taggable

  def reindex_taggable
    taggable.reload.reindex
  end
end
