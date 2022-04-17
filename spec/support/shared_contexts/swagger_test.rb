# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable Style/IfUnlessModifier
shared_context 'with swagger test' do
  before do |example|
    unless example.metadata[:path_item][:template].starts_with? '/api/v1'
      example.metadata[:path_item][:template] = example.metadata[:path_item][:template].prepend('/api/v1')
    end
  end

  run_test!

  after do |example|
    example.metadata[:response][:content] = {
      'application/json' => {
        example: JSON.parse(response.body, symbolize_names: true)
      }
    }

    example.metadata[:path_item][:template].delete_prefix!('/api/v1')
  end
end
# rubocop:enable Style/IfUnlessModifier
