class Comment::ShowPayload < ApplicationPayload
  def self.create(comment)
    {
      data: (
        comment.subtree.arrange_serializable do |parent, children|
          { **CommentSerializer.call(parent)[:data], children: children }
        end
      )[0],
      meta: { descendant_count: comment.descendant_ids.count }
    }
  end
end
