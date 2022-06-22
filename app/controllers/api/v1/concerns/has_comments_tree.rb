module Api::V1::Concerns::HasCommentsTree
  extend ActiveSupport::Concern

  included do
    include Api::V1::Concerns::Paginator
    include Api::V1::Concerns::Response

    def comments_for(comments)
      paginated = paginate(comments.roots, pagination_params)

      json_response Comment::TreePayload.create(paginated, paginated.collection, comments_options)
    end

    def comments_options
      params.fetch(:comments, {}).permit(:take_answers_number, :with_relationships)
    end
  end
end
