class AccountsController < ApplicationController
    def signup
        p session
        return render status: 400, json: { error: 'Bad Username', code: 1 } if !(params[:username].present? && /^[a-z0-9]+$/.match(params[:username]))
        return render status: 400, json: { error: 'Bad Password', code: 2 } if !params[:password].present? || params[:password].length < 4
        return render status: 409, json: { error: 'Username Exists', code: 3 } if Account.find_by(username: params[:username]).present?

        # TODO: username, password로 회원가입 시도
        Account.create(account_param)

        render status: 201, json: { success: true }
    end

    def signin
        return render status: 401, json: { error: 'Login Failed', code: 1 } unless account = Account.find_account(params[:username], params[:password])

        # TODO: 세션 생성
        auth_token = SecureRandom.hex
        render status: 201, json: { success: true, auth_token: auth_token } if account.update(auth_token: auth_token)
    end

    def getinfo
        return render status: 401, json: { error: 'No Session', code: 1 } unless account = Account.find_account_by_token(auth_token_param)

        auth_token = SecureRandom.hex
        render status: 200, json: { success: true, auth_token: auth_token } if account.update(auth_token: auth_token)
    end

    def logout
        return render status: 401, json: { error: 'No Session', code: 1 } unless account = Account.find_account_by_token(auth_token_param)

        render status: 200, json: { success: true } if account.update(auth_token: nil)
    end

    private
    def account_param
        {
            username: params[:username],
            password: params[:password]
        }
    end

    def auth_token_param
        params[:auth_token]
    end
end
