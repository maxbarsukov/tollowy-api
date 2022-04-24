describe Admin::PostPolicy, type: :policy do
  subject(:post_policy) { described_class }

  context 'when current user is not admin' do
    let(:user) { create(:user, :with_user_role) }

    permissions :update?, :destroy? do
      it 'denies access to update and destroy post' do
        another_user = create(:user, :with_user_role)
        post = create(:post, user: another_user)
        expect(post_policy).not_to permit(another_user, post)
      end
    end
  end

  context 'when current user is admin' do
    let(:user) { create(:user, :with_admin_role) }

    permissions :update?, :destroy? do
      it 'grants access to manage posts of another non-admin user' do
        another_user = create(:user, :with_user_role)
        post = create(:post, user: another_user)
        expect(post_policy).to permit(user, post)
      end

      it 'denies access to manage posts of another admin user' do
        another_user = create(:user, :with_admin_role)
        post = create(:post, user: another_user)
        expect(post_policy).not_to permit(user, post)
      end

      it 'grants access to manage your posts' do
        post = create(:post, user: user)
        expect(post_policy).to permit(user, post)
      end
    end
  end
end
