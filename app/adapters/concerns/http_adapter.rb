module HttpAdapter
  extend ActiveSupport::Concern

  included do
    attr_reader :failed

    def make_request(response, good_response, bad_response)
      unless response.success?
        @failed = true
        return bad_response.new(response)
      end

      good_response.new(Oj.load(response.body, symbol_keys: true))
    end
  end
end
