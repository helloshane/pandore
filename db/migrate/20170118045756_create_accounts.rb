class CreateAccounts < ActiveRecord::Migration[5.0]
  def change
    create_table :accounts do |t|
      t.string :pandore_id, limit: 12, comment: '账户id,用户资金流转'
      t.decimal :amount, precision: 20, scale: 2, default: 0.0, comment: '余额'
      t.integer :account_type, comment: '账户类型'
      t.timestamps null: false
    end
    add_index :accounts, :pandore_id, unique: true
  end
end
