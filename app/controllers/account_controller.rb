class AccountController < ApplicationController
    def signup
        json_response({success: true})
    end

    def signin
        json_response({success: true})
    end

    def getinfo
        json_response({info: null})
    end

    def logout
        json_response({success: true})
    end
end