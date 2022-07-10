ActiveAdmin.register Post do
  permit_params :body

  includes({ user: %i[roles roles_users] })

  index do
    selectable_column
    id_column
    column :body do |post|
      para truncate(post.body, length: 30)
    end
    column :user

    column :comments_count

    column :likes_count
    column :dislikes_count
    column :score

    column :created_at
    column :updated_at
    actions
  end

  show do
    attributes_table do
      row :body
      row :user

      row :created_at
      row :updated_at

      row :comments_count
      row :likes_count
      row :dislikes_count
      row :score

      table_for post.tags.order('created_at DESC') do
        column "Tags (#{post.tags.count})" do |tag|
          link_to "##{tag.name}", admin_tag_path(tag)
        end
      end
    end

    active_admin_comments
  end

  filter :body
  filter :user_id
  filter :created_at
  filter :updated_at

  form do |f|
    f.inputs do
      f.input :body
    end
    f.actions
  end

  before_create do |post|
    post.user = current_user
  end
end
