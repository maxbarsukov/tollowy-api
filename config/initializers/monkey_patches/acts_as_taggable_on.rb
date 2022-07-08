class ActsAsTaggableOn::Tagging
  belongs_to :tagger, polymorphic: true, optional: true
end
