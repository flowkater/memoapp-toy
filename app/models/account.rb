class Account < ApplicationRecord
  has_secure_password

  has_many :memos

  def self.find_account(username, password)
    self.find_by(username: username).try(:authenticate, password.to_s)
  end

  def self.find_account_by_token(token)
    return nil unless token.present?
    self.find_by(auth_token: token)
  end
end
