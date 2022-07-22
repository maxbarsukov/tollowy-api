module HttpAdapter
  extend ActiveSupport::Concern

  included do
    attr_reader :failed

    def make_request(response, good_response, bad_response)
      unless check_success(response)
        @failed = true
        return bad_response.new(response)
      end

      good_response.new(Oj.load(response.body, symbol_keys: true))
    end

    def check_success(response) = response.success?

    def success?
      !@failed
    end
  end
end
