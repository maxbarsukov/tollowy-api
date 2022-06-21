describe Admin::CommentPolicy, type: :policy do
  subject(:comment_policy) { described_class }

  context 'when current user is not admin' do
    let(:user) { create(:user, :with_user_role) }

    permissions :update?, :destroy? do
      it 'denies access to manage comment' do
        another_user = create(:user, :with_user_role)
        comment = create(:comment, user: another_user)
        expect(comment_policy).not_to permit(another_user, comment)
      end
    end
  end

  context 'when current user is admin' do
    let(:user) { create(:user, :with_admin_role) }

    permissions :update?, :destroy? do
      it 'grants access to manage comments of another non-admin user' do
        another_user = create(:user, :with_user_role)
        comment = create(:comment, user: another_user)
        expect(comment_policy).to permit(user, comment)
      end

      it 'denies access to manage comments of another admin user' do
        another_user = create(:user, :with_admin_role)
        comment = create(:comment, user: another_user)
        expect(comment_policy).not_to permit(user, comment)
      end

      it 'grants access to manage your comments' do
        comment = create(:comment, user: user)
        expect(comment_policy).to permit(user, comment)
      end
    end
  end
end
