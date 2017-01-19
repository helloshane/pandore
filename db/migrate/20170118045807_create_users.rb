class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :auth_token, limit: 40
      t.timestamps null: false
    end
    add_index :users, :auth_token, unique: true
    add_reference :users, :account, foreign_key: true
  end
end
