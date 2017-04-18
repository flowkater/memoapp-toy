class Account < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :validatable

  has_many :memos

  def self.find_account(email, password)
    user = self.find_by(email: email)
    return user.try(:valid_password?, password) ? user : nil
  end

  def self.find_account_by_token(token)
    return nil unless token.present?
    self.find_by(auth_token: token)
  end
end
