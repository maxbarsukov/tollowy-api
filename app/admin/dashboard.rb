# frozen_string_literal: true

ActiveAdmin.register_page 'Dashboard' do
  menu priority: 1, label: proc { I18n.t('active_admin.dashboard') }

  content title: proc { I18n.t('active_admin.dashboard') } do
    div class: 'blank_slate_container', id: 'dashboard_default_message' do
      span class: 'blank_slate' do
        span I18n.t('active_admin.dashboard_welcome.welcome')
        small I18n.t('active_admin.dashboard_welcome.call_to_action')
      end
    end

    # Here is an example of a simple dashboard with columns and panels.
    #
    columns do
      column do
        panel 'Recent Posts' do
          ul do
            Post.includes([:user]).order(created_at: :desc).take(5).map do |post|
              li do
                span link_to(truncate(post.body, length: 15), admin_post_path(post))
                span 'by'
                span link_to(post.user.username, admin_user_path(post))
              end
            end
          end
        end
      end

      if current_user.dev?
        column do
          panel 'Dev' do
            panel 'Links' do
              div link_to('Sidekiq Web', sidekiq_path)
              div link_to('PgHero', pghero_path)
            end

            panel 'Debug' do
              panel 'Current User' do
                div do
                  b 'ID: '
                  span current_user.id
                end

                div do
                  b 'Username: '
                  span current_user.username
                end

                div do
                  b 'Role: '
                  span current_user.role.name
                end
              end
            end
          end
        end
      end
    end
  end
end
