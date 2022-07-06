describe Admin::ActiveAdmin::CommentPolicy, type: :policy do
  subject(:comment_policy) { described_class }

  let(:user) { create(:user, :with_admin_role) }

  context 'when current user is author' do
    permissions :destroy? do
      it 'grants access to destroy comment' do
        comment = ActiveAdmin::Comment.create(
          resource_id: user.id,
          namespace: 'admin',
          body: 'My comment body',
          resource_type: 'User',
          author_id: user.id,
          author_type: 'User'
        )
        expect(comment_policy).to permit(user, comment)
      end
    end
  end

  context 'when current user is not author' do
    permissions :destroy? do
      it 'denies access to destroy comment' do
        another_user = create(:user, :with_admin_role)

        comment = ActiveAdmin::Comment.create(
          resource_id: another_user.id,
          namespace: 'admin',
          body: 'My comment body',
          resource_type: 'User',
          author_id: another_user.id,
          author_type: 'User'
        )
        expect(comment_policy).not_to permit(user, comment)
      end
    end
  end
end
