class Account < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :memos

  def self.find_account(username, password)
    self.find_by(username: username).try(:authenticate, password.to_s)
  end

  def self.find_account_by_token(token)
    return nil unless token.present?
    self.find_by(auth_token: token)
  end
end
