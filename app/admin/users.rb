ActiveAdmin.register User do
  permit_params :email, :username, :password, :role_value

  includes(%i[roles_users roles])

  index do
    selectable_column
    id_column
    column :email
    column :username

    column :role, &:role_value

    column :posts_count
    column :comments_count

    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    actions
  end

  show do
    attributes_table do
      row :email
      row :username

      row :role
      row :role_value
      row :role_before_reconfirm_value

      row :created_at
      row :updated_at
      row :password_reset_sent_at
      row :confirmed_at

      row :sign_in_count
      row :current_sign_in_at
      row :last_sign_in_at
      row :current_sign_in_ip
      row :last_sign_in_ip

      table_for user.providers do
        column I18n.t('active_admin.users.show.providers') do |provider|
          table_for provider do
            column :name
            column :uid
          end
        end
      end

      table_for user do
        column(I18n.t('active_admin.users.attributes.posts_count')) { |user| span user.posts_count }
        column(I18n.t('active_admin.users.attributes.comments_count')) { |user| span user.comments_count }

        column(I18n.t('active_admin.users.attributes.followers_count')) { |user| span user.followers_count }
        column(I18n.t('active_admin.users.attributes.followings_count')) { |user| span user.follow_count }
      end

      table_for user do
        column(I18n.t('active_admin.users.attributes.votes_count')) { |u| span u.votes.count }
        column(I18n.t('active_admin.users.attributes.likes_count')) { |u| span u.votes.up.count }
        column(I18n.t('active_admin.users.attributes.dislikes_count')) { |u| span u.votes.down.count }
        column(I18n.t('active_admin.users.attributes.votes_score')) { |u| span u.votes.up.count - u.votes.down.count }
      end

      table_for user.posts.order('created_at DESC').take(15) do
        column I18n.t('active_admin.users.show.last_posts', count: 15) do |post|
          link_to truncate(post.body, length: 100), admin_post_path(post)
        end
      end
    end

    active_admin_comments
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
      f.input :role_value
    end
    f.actions
  end
end
