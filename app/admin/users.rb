ActiveAdmin.register User do
  permit_params :email, :username, :password

  includes(%i[roles_users roles])

  index do
    selectable_column
    id_column
    column :email
    column :username
    column :role do |u|
      u.role.value
    end
    column :posts_count
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    actions
  end

  show do
    attributes_table do
      row :email
      row :username
      row :created_at
      row :updated_at
      row :password_reset_sent_at
      row :confirmed_at
      row :current_sign_in_at
      row :last_sign_in_at
      row :current_sign_in_ip
      row :last_sign_in_ip
      table_for user do
        column 'Posts Count' do |user|
          span user.posts_count
        end
      end
      table_for user.posts.order('created_at DESC') do
        column 'Posts' do |post|
          link_to truncate(post.body, length: 15), admin_post_path(post)
        end
      end
    end
  end

  filter :roles
  filter :email, as: :string
  filter :username
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at

  form do |f|
    f.inputs do
      f.input :email
      f.input :username
      f.input :password
    end
    f.actions
  end
end
