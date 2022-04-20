class PaginationParamsValidator
  attr_accessor :options

  def initialize(options)
    options[:number] ||= 1
    options[:size] ||= Pagy::DEFAULT[:items]

    @options = options
  end

  def validate
    check_invalid_number!
    check_invalid_size!

    @options[:number] = @options[:number].to_i || 1
    @options[:size] = @options.delete(:size).to_i || Pagy::DEFAULT[:items]

    check_size_count!

    @options
  end

  private

  def check_invalid_number!
    raise Pagination::PageNumberInvalidError.new(value: @options[:number]) if @options[:number].to_i <= 0
  end

  def check_invalid_size!
    raise Pagination::PageSizeInvalidError.new(value: @options[:size]) if @options[:size].to_i <= 0
  end

  def check_size_count!
    return unless @options[:size] > Pagy::DEFAULT[:max_per_page]

    raise Pagination::PageSizeIsTooLargeError.new(value: @options[:size])
  end
end
