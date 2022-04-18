require 'rails_helper'

describe User::Events::Create do
  include_context 'with interactor'

  let(:initial_context) { { user: user, event: :user_registered } }
  let(:user) { create(:user, username: 'John11') }
  let(:event) { user.events.last }

  describe '.call' do
    it_behaves_like 'success interactor'

    it 'creates registered event' do
      expect { interactor.run }.to change { user.events.count }.by(1)

      expect(event).to have_attributes(
        event: 'user_registered',
        title: 'New user registered with the next attributes:' \
               "\n Username - #{user.username}\n"
      )
    end
  end
end
