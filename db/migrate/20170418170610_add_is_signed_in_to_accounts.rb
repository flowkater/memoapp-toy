class AddIsSignedInToAccounts < ActiveRecord::Migration[5.0]
  def change
    add_column :accounts, :is_signed_in, :boolean, index: true
  end
end
