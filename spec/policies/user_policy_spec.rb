describe UserPolicy, type: :policy do
  subject(:user_policy) { described_class }

  context 'when current user is admin' do
    let(:current_user) { create(:user, :with_admin_role) }

    permissions :update? do
      it 'grants access to update any user' do
        user = create(:user, :with_user_role)
        expect(user_policy).to permit(current_user, user)
      end
    end
  end

  context 'when current user is not admin' do
    let(:current_user) { create(:user, :with_user_role) }

    permissions :update? do
      it 'grants access to update current user' do
        expect(user_policy).to permit(current_user, current_user)
      end

      it 'denies access to update another user' do
        user = create(:user, :with_user_role)
        expect(user_policy).not_to permit(current_user, user)
      end
    end
  end

  describe 'Scope' do
    let(:user) { create(:user, :with_user_role) }
    let(:scope) { Pundit.policy_scope!(user, User) }

    it 'allows access to all the reports' do
      expect(scope.to_a).to match_array([user])
    end
  end
end
