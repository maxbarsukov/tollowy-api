class Version::Paginate
  include Interactor

  delegate :controller, :versions, to: :context

  def call
    version_query = VersionQuery.new(versions, controller.send(:query_params))
    paginated = controller.send(:paginate, version_query.results, controller.send(:pagination_params))
    context.versions = paginated
  end
end
