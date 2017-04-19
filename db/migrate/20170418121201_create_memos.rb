class CreateMemos < ActiveRecord::Migration[5.0]
  def change
    create_table :memos do |t|
      t.references :account, foreign_key: true
      t.string :content
      t.boolean :is_edited, default: false

      t.timestamps
    end
  end
end
