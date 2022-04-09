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
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    actions
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
      f.input :password
      f.input :role
    end
    f.actions
  end
end
