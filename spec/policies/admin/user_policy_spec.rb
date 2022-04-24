describe Admin::UserPolicy, type: :policy do
  subject(:user_policy) { described_class }

  describe '#update?' do
    context 'when current user is not admin' do
      let(:user) { create(:user, :with_user_role) }

      permissions :update? do
        it 'denies access to update user' do
          expect(user_policy).not_to permit(user, user)
        end
      end
    end

    context 'when current user is admin' do
      let(:user) { create(:user, :with_admin_role) }

      permissions :update? do
        it 'grants access to update another non-admin user' do
          another_user = create(:user, :with_user_role)
          expect(user_policy).to permit(user, another_user)
        end

        it 'denies access to update another admin user' do
          another_user = create(:user, :with_admin_role)
          expect(user_policy).not_to permit(user, another_user)
        end

        it 'grants access to update yourself' do
          expect(user_policy).to permit(user, user)
        end
      end
    end
  end

  describe '#destroy?' do
    context 'when current user is not admin' do
      let(:user) { create(:user, :with_user_role) }

      permissions :destroy? do
        it 'denies access to destroy user' do
          expect(user_policy).not_to permit(user, user)
        end
      end
    end

    context 'when current user is admin' do
      let(:user) { create(:user, :with_admin_role) }

      permissions :destroy? do
        it 'grants access to destroy another non-admin user' do
          another_user = create(:user, :with_user_role)
          expect(user_policy).to permit(user, another_user)
        end

        it 'denies access to destroy another admin user' do
          another_user = create(:user, :with_admin_role)
          expect(user_policy).not_to permit(user, another_user)
        end

        it 'denies access to destroy yourself' do
          expect(user_policy).not_to permit(user, user)
        end
      end
    end
  end
end
