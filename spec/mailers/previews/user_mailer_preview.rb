# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/user_mailer

class UserMailerPreview < ActionMailer::Preview
  def new_ip_sign_in
    UserMailer.new_ip_sign_in(FactoryBot.build(:user), '178.76.227.228', 'Russia, Rostov-on-Don')
  end
end
