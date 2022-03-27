describe RolePolicy, type: :policy do
  include PunditHelper

  subject(:role_policy) { described_class }

  it 'requires a user in good standing' do
    user = create(:user, :with_banned_role)
    expect do
      role_policy.new(user, user, :user)
    end.to raise_error(Auth::UserSuspendedError)
  end

  permissions :update? do
    context 'when current user is admin' do
      let(:current_user) { create(:user, :with_admin_role) }

      context "when updates current user's role" do
        it 'denies access to update current user' do
          expect(role_policy).not_to permit_with_multiple(current_user, current_user, :user)
        end
      end

      context 'when updates user with higher role' do
        it 'denies access to update user' do
          user = create(:user, :with_user_role)
          expect(role_policy).not_to permit_with_multiple(current_user, user, :admin)
        end
      end

      context 'when updates fits user' do
        it 'grants access to update user' do
          user = create(:user, :with_user_role)
          expect(role_policy).to permit_with_multiple(current_user, user, :moderator)
        end
      end
    end

    context 'when current user is user' do
      let(:current_user) { create(:user, :with_user_role) }

      it 'denies access to update any user' do
        user = create(:user, :with_user_role)
        expect(role_policy).not_to permit_with_multiple(current_user, user, :banned)
      end
    end
  end
end
