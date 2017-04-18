class RegistrationsController < ApplicationController
  def create
    return render status: 400, json: { error: 'Bad Username', code: 1 } unless matches = /^[a-z0-9]+$/.match(params.username)
    return render status: 400, json: { error: 'Bad Password', code: 2 } unless password.length < 4
    return render status: 409, json: { error: 'Username Exists', code: 3 } unless Account.name.exists?
    render status: 201, json: { success: true }
  end
end
