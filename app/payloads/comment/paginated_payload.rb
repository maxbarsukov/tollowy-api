class Comment::PaginatedPayload < ApplicationPayload
  def self.create(obj)
    {
      **CommentSerializer.call(obj.collection),
      links: obj.links,
      meta: obj.meta
    }
  end
end
