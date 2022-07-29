# frozen_string_literal: true

require 'rails_helper'

describe User::UpdateTrackableData do
  include_context 'with interactor'

  before do
    request_stub = Class.new do
      attr_accessor :remote_ip

      def initialize(remote_ip)
        @remote_ip = remote_ip
      end
    end

    stub_const('RequestStub', request_stub)
    travel_to Time.zone.local(2022)
  end

  after { travel_back }

  let(:initial_context) { { user:, request: RequestStub.new('::1') } }

  describe '.call' do
    context 'with valid data' do
      let(:user) { create(:user, :with_user_role) }

      it_behaves_like 'success interactor'

      it 'updates user trackable data' do
        interactor.run

        expect(context.user).to be_persisted
        expect(context.user).to have_attributes(
          sign_in_count: 1,
          current_sign_in_at: Time.now.utc,
          current_sign_in_ip: '::1'
        )
      end
    end

    context 'with invalid data' do
      let(:user) { build(:user, :with_user_role, email: 'bad email') }

      let(:error_data) do
        { status: '422', code: :unprocessable_entity, title: 'Invalid user' }
      end

      it_behaves_like 'failed interactor'
    end
  end
end
