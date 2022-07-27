# frozen_string_literal: true

require 'rails_helper'

describe Vk::UserBuilder do
  subject(:user_builder) { described_class }

  let!(:user_response) do
    response = {
      response: [
        {
          id: '12',
          screen_name: 'maxbarsukov',
          first_name: 'Max',
          last_name: 'Barsukov',
          status: 'Hello',
          site: 'Not a site',
          about: 'Its me'
        }
      ]
    }
    Response::Vk::UserGetResponse.new(response)
  end

  describe '#initialize' do
    it 'creates builder' do
      user_response.email = 'max@mail.ru'
      builder = user_builder.new(user_response)
      expect(builder.user_response).to eq(user_response)
    end
  end

  describe '#build' do
    it 'builds new user' do
      user_response.email = 'max@mail.ru'
      builder = user_builder.new(user_response)
      user = builder.build
      expect(user).to have_attributes(
        username: 'maxbarsukov',
        email: 'max@mail.ru',
        bio: 'Hello. Its me',
        location: nil,
        blog: nil
      )
    end
  end
end
