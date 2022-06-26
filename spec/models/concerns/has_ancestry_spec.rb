# frozen_string_literal: true

require 'rails_helper'

describe HasAncestry do
  let!(:post) { create(:post) }
  let!(:comment) { create(:comment, commentable: post) }
  let(:comment_child) { create(:comment, parent_id: comment.id) }

  describe '#parent_or_root_post' do
    it 'returns parent if parent exists' do
      expect(comment_child.parent_or_root_post).to eq(comment)
    end

    it 'returns root if no parent' do
      expect(comment.parent_or_root_post).to eq(post)
    end
  end

  describe '#parent_user' do
    it 'returns parent user if parent exists' do
      expect(comment_child.parent_user).to eq(comment.user)
    end

    it 'returns root user if no parent' do
      expect(comment.parent_user).to eq(post.user)
    end
  end

  describe 'root_exists?' do
    it 'returns true if root exists' do
      expect(comment_child).to be_root_exists
    end

    it 'returns false if no root' do
      expect(comment).not_to be_root_exists
    end
  end

  describe 'parent_exists??' do
    it 'returns true if parent exists' do
      expect(comment_child).to be_parent_exists
    end

    it 'returns false if no parent' do
      expect(comment).not_to be_parent_exists
    end
  end

  describe '.with_parents' do
    let!(:parent) { create(:comment) }
    let(:comments_with_parents) { create_list(:comment, 5, parent_id: parent.id) }

    it 'returns all comment with parents' do
      expect(Comment.with_parents).to eq(comments_with_parents)
    end
  end
end
