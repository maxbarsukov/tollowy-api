class Comment::PaginatePayload < ApplicationPayload
  def self.create(obj)
    {
      **CommentSerializer.call(obj.comments.collection, { params: obj.options }),
      links: obj.comments.links,
      meta: obj.comments.meta
    }
  end
end
