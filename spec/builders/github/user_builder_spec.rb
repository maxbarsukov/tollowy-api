# frozen_string_literal: true

require 'rails_helper'

describe Github::UserBuilder do
  subject(:user_builder) { described_class }

  let!(:user_response) do
    response = { id: '12', login: 'max', bio: 'bio', blog: 'maxbarsukov.vercel.app', location: 'qqq' }
    Response::Github::UserResponse.new(response)
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
        username: a_string_starting_with('max'),
        email: 'max@mail.ru',
        bio: 'bio',
        location: 'qqq'
      )
    end
  end
end
