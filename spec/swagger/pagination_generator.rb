# rubocop:disable Security/Eval
module PaginationGenerator
  module_function

  def headers(binding)
    code = %(
        header 'Link', schema: {
          type: :string,
          example: '<http://localhost:3000/api/v1/users?page%5Bnumber%5D=1&page%5Bsize%5D=5>; rel="first"'
        }, description: 'Links to another pages'

        header 'X-Total-Pages', schema: {
          type: :integer,
          example: 10,
          minimum: 1,
          maximum: Pagy::DEFAULT[:max_per_page]
        }, description: 'The total number of pages of the resource'

        header 'Per-Page', schema: {
          type: :integer,
          example: 4
        }, description: 'Resource entries per page'

        header 'Current-Page', schema: {
          type: :integer,
          example: 1
        }, description: 'Current page'

        header 'X-Total-Count', schema: {
          type: :integer,
          example: 2
        }, description: 'The total number of the resource'

        header 'Content-Range', schema: {
          type: :string,
          example: 'items 11-15/100'
        }, description: 'items from-to/count'
    )
    eval(code, binding)
  end

  def parameters(binding)
    code = %(
       parameter name: 'page[number]',
                in: :query,
                description: 'Page number',
                minimum: 1,
                default: 1,
                type: :integer,
                required: false

      parameter name: 'page[size]',
                in: :query,
                description: 'Per page',
                minimum: 1,
                maximum: Pagy::DEFAULT[:max_per_page],
                default: Pagy::DEFAULT[:items],
                type: :integer,
                required: false
    )
    eval(code, binding)
  end
end
# rubocop:enable Security/Eval
