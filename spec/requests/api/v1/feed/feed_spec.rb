# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Feed', type: :request do
  describe 'GET /feed' do
    context 'with user' do
      context 'with following users' do
        it 'returns posts created by followed users' do
          current_user = create(:user, :with_user_role)
          headers = { 'Authorization' => ApiHelper.authenticated_header(user: current_user) }

          user1 = create(:user, :with_user_role)
          p1 = user1.posts.create!(body: 'Hello, its me')
          p2 = user1.posts.create!(body: 'Im posting some posts')

          user2 = create(:user, :with_moderator_role)
          p3 = user2.posts.create!(body: '#tags i love')

          user3 = create(:user, :with_user_role)
          _p4 = user3.posts.create!(body: 'Good morning, sir')
          p5 = user3.posts.create!(body: '#TAGS')

          current_user.follow Tag.find_by(name: 'tags')
          current_user.follow user1
          current_user.follow user2

          posts = [p5, p3, p2, p1]
          expected_bodies = posts.map(&:body)

          get '/api/v1/feed', headers: headers

          actual_bodies = JSON.parse(response.body, symbolize_names: true)[:data].map { |p| p[:attributes][:body] }

          expect(response).to have_http_status(:ok)
          expect(JSON.parse(response.body)['meta']['total']).to eq(4)

          expect(expected_bodies).to match_array(actual_bodies)
        end
      end

      context 'without following users' do
        it 'returns NoPostsPayload' do
          user = create(:user, :with_user_role)
          headers = { 'Authorization' => ApiHelper.authenticated_header(user:) }
          get '/api/v1/feed', headers: headers

          expect(response).to have_http_status(:ok)
          expect(JSON.parse(response.body)['data']).to eq([])
          expect(JSON.parse(response.body)['meta']['total']).to eq(0)
          expect(JSON.parse(response.body)['meta']['message']).to eq('You have no posts in your feed')
        end
      end
    end

    context 'without user' do
      it 'fails with unauthorized' do
        headers = { 'Authorization' => 'Bearer 123' }
        get '/api/v1/feed', headers: headers

        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)['errors'][0]['title']).to eq(
          'You need to sign in or sign up before continuing'
        )
      end
    end
  end
end
