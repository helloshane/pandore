module Entities
  module V1
    class AccountDetailEntity < Grape::Entity
      root 'account_detail'

      # 余额
      expose :money, as: 'balance'

      # 借出金额
      expose :credit_deals_money, as: 'credit_money' 

      # 借入金额
      expose :debit_deals_money, as: 'debit_money'
    end
  end
end
