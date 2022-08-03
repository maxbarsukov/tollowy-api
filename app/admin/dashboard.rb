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
        panel I18n.t('active_admin.dashboard_messages.recent_posts') do
          ul do
            Post.includes([:user]).order(created_at: :desc).take(5).map do |post|
              li do
                span link_to(truncate(post.body, length: 15), admin_post_path(post))
                span I18n.t('active_admin.dashboard_messages.by')
                span link_to(post.user.username, admin_user_path(post))
              end
            end
          end
        end
      end

      if current_user.dev?
        column do
          panel I18n.t('active_admin.dashboard_messages.dev') do
            panel I18n.t('active_admin.dashboard_messages.links') do
              div link_to('Sidekiq Web', sidekiq_path)
              div link_to('PgHero', pghero_path)
            end

            panel I18n.t('active_admin.dashboard_messages.debug') do
              panel I18n.t('active_admin.dashboard_messages.current_user.title') do
                div do
                  b I18n.t('active_admin.dashboard_messages.current_user.id')
                  span current_user.id
                end

                div do
                  b I18n.t('active_admin.dashboard_messages.current_user.username')
                  span current_user.username
                end

                div do
                  b I18n.t('active_admin.dashboard_messages.current_user.role')
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
