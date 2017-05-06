class AccountsController < ApplicationController
    before_action :authenticate_request!, only: [:logout, :getinfo, :search]

    def search
      return render_error 422, 6, 'E-mail은 필수' unless email_param.present?

      email_query = "%"+email_param+"%"
      accounts = Account.where("email LIKE ?", email_query)

      render_success :ok, { accounts: accounts }
    end

    def signup
        return render_error 422, 1, 'E-mail 형식을 확인하세요' if !(params[:email].present? && /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i.match(params[:email]))
        return render_error 422, 2, '비밀번호는 8자리 이상이어야 합니다.' if !params[:password].present? || params[:password].length < 8
        return render_error 422, 3, 'E-mail이 이미 존재합니다.' if Account.find_by(email: params[:email]).present?

        account = Account.create!(account_param)

        render_success :created, { account: account }
    end

    def signin
        return render_error 422, 1, '로그인에 실패 했습니다.' unless account = Account.find_account(params[:email], params[:password])

        account.sign_in

        render_success :ok, { account: account, auth_token: JsonWebToken.get_token(account) } if account.present?
    end

    def logout
        current_account.sign_out

        render_success :ok, { account: current_account }
    end

    def getinfo
      return render_error 422, 1, 'No Session' unless JsonWebToken.get_token(current_account) == http_token

      render_success :ok, { account: current_account, auth_token: JsonWebToken.get_token(current_account) }
    end

    private
    def email_param
        params[:email]
    end

    def account_param
        {
            email: params[:email],
            password: params[:password]
        }
    end

    def auth_token_param
        params[:auth_token]
    end
end
