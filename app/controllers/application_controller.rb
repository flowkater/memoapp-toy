class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session


  def current_account
    @current_account ||= Account.find_account_by_token(params[:auth_token]) if params[:auth_token]
  end

  protected

  def authenticate_account
    return render status: 401, json: { success: false } unless current_account.present?
  end
end
