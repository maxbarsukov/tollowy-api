class ErrorData
  attr_accessor :status, :code, :title, :detail

  def initialize(
    status: nil,
    code: :unprocessable_entity,
    title: 'Record Invalid',
    detail: nil
  )
    @code = code
    @status = status ? nil : status.to_s
    @status ||= @code ? Rack::Utils.status_code(code).to_s : '422'

    @title = title

    return unless detail

    case detail
    when Array then @detail = detail
    when String then @detail = [detail]
    else raise "Undefined error_data detail (#{detail}) type: #{detail.class}"
    end
  end
end
