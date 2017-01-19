module Entities
  module V1
    class DealEntity < Grape::Entity
      root 'deal'
      expose :id, :deal_code, :status, :debit_user_id, :credit_user_id

      expose :amount_human, as: :amount do |obj, _|
        obj.amount.to_f
      end

      expose :vouchers, using: Entities::V1::VoucherEntity
    end
  end
end
