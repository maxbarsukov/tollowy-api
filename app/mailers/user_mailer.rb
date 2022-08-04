class UserMailer < ApplicationMailer
  def new_ip_sign_in(user, ip, location)
    @title = I18n.t('mailers.user.new_ip_sign_in.title')
    @user = user
    @ip = ip
    @location = location

    mail(to: user.email, subject: "#{@title} | Followy")
  end
end
