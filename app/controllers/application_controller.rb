class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def current_account
    @current_account ||= Account.find(session[:login_info]) if session[:login_info]
  end


end
