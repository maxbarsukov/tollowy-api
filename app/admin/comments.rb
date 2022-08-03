ActiveAdmin.register Comment do
  permit_params :body, :commentable_type, :commentable_id

  includes({ user: %i[roles roles_users] }, :commentable)

  batch_action :mark_edited do |ids|
    Comment.where(id: ids).update_all(edited: true, edited_at: Time.now.utc)
    redirect_to collection_path, notice: I18n.t('active_admin.comments.batch.mark_edited.message')
  end

  batch_action :unmark_edited do |ids|
    Comment.where(id: ids).update_all(edited: false, edited_at: nil)
    redirect_to collection_path, notice: I18n.t('active_admin.comments.batch.unmark_edited.message')
  end

  index do
    selectable_column
    id_column

    column :body do |post|
      para truncate(post.body, length: 30)
    end
    column :user
    column :commentable

    column :likes_count
    column :dislikes_count
    column :score

    column :edited
    column :created_at
    column :edited_at

    actions
  end

  show do
    attributes_table do
      row :body
      row :user

      row :commentable

      row :edited

      row :created_at
      row :edited_at

      row :likes_count
      row :dislikes_count
      row :score
    end

    active_admin_comments
  end

  filter :body
  filter :user_id
  filter :commentable_id
  filter :commentable_type
  filter :edited
  filter :created_at
  filter :edited_at

  form do |f|
    f.inputs do
      f.input :body
      f.input :commentable_type, collection: %w[Post Comment]
      f.input :commentable_id
    end
    f.actions
  end

  before_create do |comment|
    comment.user = current_user
  end

  after_update do |comment|
    comment.edited = true
    comment.edited_at = Time.now.utc
    comment.save!
  end
end
