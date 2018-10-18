class ApplicationController < ActionController::Base

  helper_method :user_signed_in?
  
  protect_from_forgery with: :exception
  include SessionsHelper

  before_action :set_current_user

  def set_current_user
    @current_user = User.find_by(id: session[:user_id])
  end

  def authenticate_user!
    if @current_user == nil
      flash[:notice] = "ログインが必要です"
      redirect_to("/login")
    end
  end

  def forbid_login_user
    if @current_user
      flash[:notice] = "すでにログインしています"
      redirect_to("/user")
    end
  end

  def user_signed_in?
    current_user.present?
  end

end
