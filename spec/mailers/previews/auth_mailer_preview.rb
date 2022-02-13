# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/auth_mailer

class AuthMailerPreview < ActionMailer::Preview
  def password_recovery
    AuthMailer.password_recovery(
      FactoryBot.build(:user, password_reset_token: '1234')
    )
  end
end
