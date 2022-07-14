module Pagination
  class Error < StandardError
    attr_accessor :data, :source

    def initialize(msg = nil, param:, value:, detail:) # rubocop:disable Lint/UnusedMethodArgument
      @data = ErrorData.new(
        status: 400,
        code: :bad_request,
        title: msg,
        detail:
      )
      @source = { parameter: param }
      super(msg)
    end
  end

  class InvalidParameter < Error
    def initialize(
      msg = 'Invalid Parameter',
      param:,
      value:,
      detail: "#{param} must be a positive integer; got #{value}"
    )
      super
    end
  end

  class PageNumberInvalidError < InvalidParameter
    def initialize(
      msg = 'Invalid Parameter',
      value:, param: 'page[number]',
      detail: "#{param} must be a positive integer; got #{value}"
    )
      super
    end
  end

  class PageSizeInvalidError < InvalidParameter
    def initialize(
      msg = 'Invalid Parameter',
      value:, param: 'page[size]',
      detail: "#{param} must be a positive integer; got #{value}"
    )
      super
    end
  end

  class PageSizeIsTooLargeError < InvalidParameter
    def initialize(
      msg = 'Page size requested is too large',
      param: 'page[size]',
      value: nil,
      detail: "page[size] 100 is the maximum; got #{value}"
    )
      super
    end
  end
end
