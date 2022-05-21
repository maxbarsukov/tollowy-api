class Schemas::CommentChildren < Schemas::Base
  def self.data
    {
      title: 'Comment Children',
      description: 'Array of comment children',
      type: :array,
      items: Schemas::Comment.ref
    }
  end
end
