module Entities
  module V1
    class VoucherEntity < Grape::Entity
      expose :id, :voucher_code, :amount, :trade_type, :status, :income_user_id, :expense_user_id
    end
  end
end