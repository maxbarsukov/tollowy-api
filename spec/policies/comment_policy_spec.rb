describe CommentPolicy, type: :policy do
  subject(:comment_policy) { described_class }

  context 'when current user is admin' do
    let(:current_user) { create(:user, :with_admin_role) }

    permissions :update?, :destroy? do
      it 'grants access to manage any comment' do
        comment = create(:comment)
        expect(comment_policy).to permit(current_user, comment)
      end
    end
  end

  context 'when current user is not admin' do
    let(:current_user) { create(:user, :with_user_role) }

    permissions :update?, :destroy? do
      it 'grants access to manage own comments' do
        comment = create(:comment, user: current_user)
        expect(comment_policy).to permit(current_user, comment)
      end

      it 'denies access to update another user' do
        comment = create(:comment, user: create(:user, :with_user_role))
        expect(comment_policy).not_to permit(current_user, comment)
      end
    end
  end
end
