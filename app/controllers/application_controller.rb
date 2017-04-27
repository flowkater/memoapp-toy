class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  attr_reader :current_account

  before_action :set_cors_headers

  protected
  def set_cors_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS'
    headers['Access-Control-Request-Method'] = '*'
    headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
  end

  def authenticate_request!
    unless account_id_in_token?
      render_error :unauthorized, 401, 'Not Authenticated'
      return
    end
    @current_account = Account.where(is_signed_in: true).find(auth_token[:account_id])
  rescue ActiveRecord::RecordNotFound
    render_error 404, 404, "로그인 된 사용자를 찾을 수 없음"
  rescue JWT::VerificationError, JWT::DecodeError
    render_error :unauthorized, :unauthorized, 'Not Authenticated'
  end

  def render_success(status_code, response_json = {})
    render_json(status_code, response_json)
  end

  def render_error(status_code, error_code, message)
    response_json = {
      error: {
        code: error_code,
        message: message
      }
    }

    render_json(status_code, response_json)
  end

  def render_json(status_code, response_json)
    render status: status_code, json: response_json
  end

  private
  def http_token
      @http_token ||= if request.headers['Authorization'].present?
        request.headers['Authorization'].split(' ').last
      end
  end

  def auth_token
    @auth_token ||= JsonWebToken.decode(http_token)
  end

  def account_id_in_token?
    http_token && auth_token && auth_token[:account_id].to_i
  end
end
