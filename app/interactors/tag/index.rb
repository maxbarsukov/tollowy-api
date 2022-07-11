class Tag::Index
  include Interactor::Organizer

  before do
    context.tags = Tag.all
  end

  organize Tag::Paginate
end
