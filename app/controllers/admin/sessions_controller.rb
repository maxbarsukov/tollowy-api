class Admin::SessionsController < ApplicationController
  def index; end

  def new
    redirect_to admin_root_path, alert: I18n.t('admin.sessions.alert.already_signed_in') if user_signed_in?
  end

  def create
    result = Auth::SignIn.call(login_params.merge({ request: request }))

    if result.success?
      session[:access_token] = result.access_token
      redirect_to admin_root_path, notice: I18n.t('admin.sessions.notice.logged_in_successfully')
    else
      flash.now[:alert] = I18n.t('admin.sessions.alert.invalid')
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    reset_session
    redirect_to admin_root_path, notice: I18n.t('admin.sessions.notice.logged_out')
  end

  private

  def login_params
    params.require(:session).permit(:email, :password)
  end
end
