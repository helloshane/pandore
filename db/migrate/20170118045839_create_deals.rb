class CreateDeals < ActiveRecord::Migration[5.0]
  def change
    create_table :deals do |t|
      t.decimal :amount, precision: 20, scale: 2, default: 0.0, comment: '当前交易金额'
      t.integer :debit_user_id, comment: '借款方'
      t.integer :credit_user_id, comment: '放款方'
      
      t.string  :deal_code, limit: 12, comment: '交易码'
      t.integer :status
      t.datetime :loaned_at
      t.datetime :refunded_at
      t.timestamps null: false
    end

    add_index :deals, :deal_code, unique: true
    add_index :deals, :debit_user_id
    add_index :deals, :credit_user_id
    add_index :deals, :status
  end
end
