require 'rails_helper'

describe Auth::SignIn do
  describe '#after' do
    let(:user_id) { 213_689 }
    let(:user) { create :user, id: user_id }
    let(:initial_context) { { user: } }
    let(:event) { :user_logged_in }

    context 'when organizer succeeds' do
      include_context 'with stubbed organizer'

      it_behaves_like 'event source'
    end

    context 'when organizer failures' do
      include_context 'with stubbed organizer', failure: true

      it 'does not schedule create event job' do
        expect { interactor.run }.not_to have_enqueued_job(Events::CreateUserEventJob)
      end
    end
  end
end
