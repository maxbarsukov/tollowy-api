# frozen_string_literal: true

require 'rails_helper'

shared_context 'with swagger test' do
  run_test!

  after do |example|
    example.metadata[:response][:content] = {
      'application/json' => {
        example: JSON.parse(response.body, symbolize_names: true)
      }
    }
  end
end
