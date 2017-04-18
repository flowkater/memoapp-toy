class AccountsController < ApplicationController
    def signup
        p session
        return render status: 400, json: { error: 'Bad E-mail', code: 1 } if !(params[:email].present?)
        return render status: 400, json: { error: 'Bad Password', code: 2 } if !params[:password].present? || params[:password].length < 4
        return render status: 409, json: { error: 'E-mail Exists', code: 3 } if Account.find_by(email: params[:email]).present?

        # TODO: email, password로 회원가입 시도
        Account.create(account_param)

        render status: 201, json: { success: true }
    end

    def signin
        return render status: 401, json: { error: 'Login Failed', code: 1 } unless account = Account.find_account(params[:email], params[:password])

        # TODO: 세션 생성
        render status: 201, json: { success: true } if account.present?
    end

    def getinfo
        return render status: 401, json: { error: 'No Session', code: 1 } unless account = Account.find_account_by_token(auth_token_param)

        render status: 200, json: { success: true } if account.present?
    end

    def logout
        return render status: 401, json: { error: 'No Session', code: 1 } unless account = Account.find_account_by_token(auth_token_param)

        render status: 200, json: { success: true } if account.update(auth_token: nil)
    end

    private
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
