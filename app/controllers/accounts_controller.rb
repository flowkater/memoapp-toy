class AccountsController < ApplicationController
    def signup
        return render status: 400, json: { error: 'Bad Username', code: 1 } unless matches = /^[a-z0-9]+$/.match(params.username)
        return render status: 400, json: { error: 'Bad Password', code: 2 } unless password.length < 4
        return render status: 409, json: { error: 'Username Exists', code: 3 } unless Account.name.exists?

        render status: 201, json: { success: true }
    end

    def signin
        return render status: 401, json: { error: 'Login Failed', code: 1 } # TODO: 비밀번호 다를때 or 계정이 존재하지 않을 때

        render status: 201, json: { success: true }
    end

    def getinfo
        return render status: 401, json: { error: 'No Session', code: 1 }

        render status: 200, json: { info: session.login_info }
    end

    def logout
        #TODO: destroy session

        render status: 200, json: { success: true }
    end
end
