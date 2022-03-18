class ErrorData
  attr_accessor :status, :code, :title, :detail

  def initialize(
    status: nil,
    code: :unprocessable_entity,
    title: 'Record Invalid',
    detail: nil
  )
    @status = status
    @code = code
    @status ||= @code ? Rack::Utils.status_code(code).to_s : 422

    @title = title
    @detail = detail if detail
  end
end
