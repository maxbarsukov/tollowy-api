class Comment::TreePayload < ApplicationPayload
  def self.create(page, obj, options = {})
    {
      **CommentTreeSerializer.new(obj, options).call,
      links: page.links,
      meta: page.meta
    }
  end
end
