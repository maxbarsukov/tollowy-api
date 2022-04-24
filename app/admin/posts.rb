ActiveAdmin.register Post do
  permit_params :body

  includes({ user: %i[roles roles_users] })

  index do
    selectable_column
    id_column
    column :body do |post|
      para truncate(post.body, length: 15)
    end
    column :user
    column :created_at
    column :updated_at
    actions
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
