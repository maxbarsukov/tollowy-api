describe Admin::ApplicationPolicy, type: :policy do
  subject(:application_policy) { described_class }

  context 'when current user is admin' do
    let(:user) { create(:user, :with_admin_role) }

    permissions :index?, :show?, :new?, :create?, :edit?, :update?, :destroy?, :destroy_all? do
      it 'grants access for any action' do
        expect(application_policy).to permit(user, user)
      end
    end
  end

  context 'when current user is not admin' do
    let(:user) { create(:user, :with_user_role) }

    permissions :index?, :show?, :new?, :create?, :edit?, :update?, :destroy?, :destroy_all? do
      it 'denies access for any action' do
        expect(application_policy).not_to permit(user, user)
      end
    end
  end

  describe '#scope' do
    it 'returns all records in scope' do
      user = create(:user, :with_admin_role)
      policy = application_policy.new(user, user)

      expect(policy.scope).to match_array([user])
    end
  end

  describe 'Scope' do
    let(:user) { create(:user, :with_admin_role) }
    let(:scope) { Admin::ApplicationPolicy::Scope.new(user, User).resolve.all }

    it 'allows access to all entities' do
      expect(scope.to_a).to match_array([user])
    end
  end
end
