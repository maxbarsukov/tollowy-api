module Api::V1::Concerns::Paginator
  extend ActiveSupport::Concern

  PaginationData = Struct.new(:pagy, :collection, :meta, :links, keyword_init: true)

  protected

  def paginate(collection, options)
    options = PaginationParamsValidator.new(options).validate
    pagy_params = { page: options[:number], items: options[:size] }

    pagy, paginated_collection = pagy(collection, pagy_params)

    pagination_headers(pagy) unless options[:no_headers]
    meta = meta(pagy)
    links = links(pagy)

    PaginationData.new(pagy: pagy, collection: paginated_collection, meta: meta, links: links)
  end

  def pagination_params
    params.fetch(:page, {}).permit(:number, :size)
  end

  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def pagination_headers(pagy)
    links = (headers['Link'] || '').split(',').map(&:strip)
    clean_url = request.original_url.sub(/\?.*$/, '')

    pages(pagy).each do |key, value|
      query_params = query_parameters(request, value)
      links << %( <#{clean_url}?#{query_params.to_param}>; rel="#{key}" )
    end

    headers['Link'] = links.join(', ') unless links.empty?
    headers['Per-Page'] = pagy.items
    headers['Current-Page'] = pagy.page
    headers['Content-Range'] = "items #{pagy.from}-#{pagy.to}/#{pagy.count}"
    headers['X-Total-Pages'] = pagy.pages
    headers['X-Total-Count'] = pagy.count
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

  def links(pagy)
    current_uri = request.env['PATH_INFO']
    {}.tap do |meta_links|
      pages(pagy).each do |key, value|
        query_params = query_parameters(request, value)
        meta_links[key] = "#{current_uri}?#{query_params.to_param}"
      end
    end
  end

  def pages(pagy)
    {}.tap do |paging|
      paging[:first] = 1
      paging[:self] = pagy.page
      paging[:last] = pagy.pages
      paging[:prev] = pagy.prev if pagy.prev.present?
      paging[:next] = pagy.next if pagy.next.present?
    end
  end

  def meta(pagy)
    {}.tap do |meta|
      meta[:total] = pagy.count
      meta[:pages] = pagy.pages
      meta[:current_page] = pagy.page
      meta[:per_page] = pagy.items
      meta[:from] = pagy.from
      meta[:to] = pagy.to
    end
  end

  private

  def query_parameters(request, value)
    request.query_parameters.merge(
      page: request.query_parameters.fetch(:page, {}).merge({ number: value })
    )
  end
end
