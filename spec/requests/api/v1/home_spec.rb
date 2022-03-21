require 'swagger_helper'

RSpec.describe 'api/v1', type: :request do
  path '/api/v1' do
    get 'check auth' do
      tags 'Auth Check'
      security [Bearer: []]

      response(200, 'successful') do
        schema type: :object,
               properties: {
                 message: { type: :string, enum: ["If you see this, you're in!"] }
               },
               required: ['message']

        examples 'application/json' => {
          message: "If you see this, you're in!"
        }

        let!(:user) { create :user }
        let!(:Authorization) { ApiHelper.authenticated_header(user: user) }
        include_context 'with swagger test'
      end

      response(401, 'unauthorized') do
        schema type: :object,
               properties: {
                 errors: {
                   type: :array,
                   items: {
                     type: :object,
                     properties: {
                       status: { type: :string, enum: ['401'] },
                       code: { type: :string, enum: ['unauthorized'] },
                       title: { type: :string, enum: ['You need to sign in or sign up before continuing'] }
                     },
                     required: %w[status code title]
                   }
                 }
               },
               required: ['errors']

        examples 'application/json' => {
          errors: [
            {
              status: '401',
              code: 'unauthorized',
              title: 'You need to sign in or sign up before continuing'
            }
          ]
        }

        let(:Authorization) { 'Bearer 12345667' }
        include_context 'with swagger test'
      end
    end
  end
end
