class Tag::Index
  include Interactor

  delegate :controller, :current_user, to: :context

  def call
    result = Tag::Paginate.call(
      controller: controller,
      tags: Tag.all,
      current_user: current_user
    )

    context.tags = result.tags
  end
end
