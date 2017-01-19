
class CreateVoucher < ActiveRecord::Migration[5.0]
  def change
    create_table :vouchers do |t|
      t.string  :deal_code, limit: 12, comment: '交易码'
      t.decimal :amount, precision: 20, scale: 2, default: 0.0, comment: '当前交易金额'
      t.string  :voucher_code, limit: 20, comment: '流水码'
      t.integer :status
      t.integer :trade_type, comment: '交易类型, 借款:loan, 还款:refund'
      t.integer :income_user_id, comment: '入账'
      t.integer :expense_user_id, comment: '出账'
    end
    add_reference :vouchers, :deal, foreign_key: true
    add_index :vouchers, :trade_type
    add_index :vouchers, :income_user_id
    add_index :vouchers, :expense_user_id
  end
end
