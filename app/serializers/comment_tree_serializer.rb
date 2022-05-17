class CommentTreeSerializer
  using StringToBoolean

  def initialize(comments_roots, options)
    @comments_roots = comments_roots
    @with_relationships = options.fetch(:with_relationships, 'false')&.to_boolean
    @take_count = options.fetch(:answers_number, 2)
  end

  def call
    {
      data: [].tap do |result|
        @comments_roots.order(created_at: :asc).map do |comment|
          result << {
            **CommentSerializer.call(comment)[:data],
            **(@with_relationships ? relationships(comment) : {})
          }
        end
      end
    }
  end

  def relationships(comment)
    {
      relationships: {
        children: (
          comment.children.order(created_at: :asc).take(@take_count).map do |c|
            CommentSerializer.call(c)[:data]
          end
        )
      }
    }
  end
end
