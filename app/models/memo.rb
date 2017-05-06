class Memo < ApplicationRecord
  belongs_to :account

  acts_as_votable
end
