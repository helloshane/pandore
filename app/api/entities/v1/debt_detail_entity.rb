module Entities
  module V1
    class DebtDetailEntity < Grape::Entity
      root 'debt_detail'

      expose :parse, merge: true

      def parse
        object.inject({}) do |result, (other_id, user)|
          result[user.id] = {
            credit_money: user.credit_deals_filter_money(other_id) ,
            debit_money: user.debit_deals_filter_money(other_id)
          }
          result
        end
      end

    end
  end
end
