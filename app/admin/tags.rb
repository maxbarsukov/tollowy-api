ActiveAdmin.register Tag do
  index do
    selectable_column
    id_column

    column :name

    column :taggings_count
    column :followers_count

    column :created_at
    column :updated_at
  end

  show do
    attributes_table do
      row :name

      row :taggings_count
      row :followers_count

      row :created_at
      row :updated_at

      table_for tag.posts.order('created_at DESC').take(15) do
        column 'Last Posts (15)' do |post|
          link_to truncate(post.body, length: 100), admin_post_path(post)
        end
      end
    end

    active_admin_comments
  end

  filter :name
  filter :created_at
  filter :updated_at
end
