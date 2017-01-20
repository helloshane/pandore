module V1
  class Deals < Grape::API
    resources :deals do
      before do
        authenticate!
        
        if params.deal_code
          @deal = Deal.find_by_deal_code(params.deal_code)
          raise_error(:deal_not_found) if @deal.nil?
        end

        if params.voucher_code
          @voucher = Voucher.find_by_voucher_code(params.voucher_code)
          raise_error(:voucher_not_found) if @voucher.nil?
        end
      end

      desc '借款交易注册', { headers: ApiRoot.auth_headers }
      params do
        requires :debit_user_id, type: Integer, desc: '借款方'
        requires :credit_user_id, type: Integer, desc: '放款方'
        requires :amount, type: BigDecimal, values: { value: BigDecimal(0)..BigDecimal('Infinity') }, desc: '金额'
      end
      post :loan_register do
        trade_users = User.where(id: [params.debit_user_id, params.credit_user_id])
        raise_error(:illegal_user_id) unless trade_users.size == 2

        result = DealService.new.register_loan(params)
        return raise_error(result.error_id) unless result.success?

        present_ok(result.data, with: Entities::V1::DealEntity)
      end

      desc '还款交易注册', { headers: ApiRoot.auth_headers }
      params do
        requires :deal_code, type: String, desc: '借款交易号'
      end
      post :refund_register do
        result = DealService.new.register_refund(@deal)
        return raise_error(result.error_id) unless result.success?

        present_ok(result.data, with: Entities::V1::DealEntity)
      end

      desc '完成一笔借款交易', { headers: ApiRoot.auth_headers }
      route_param :voucher_code do
        patch :confirm_loan do
          result = DealService.new.confirm_loan(@voucher)
          return raise_error(result.error_id) unless result.success?

          present_ok(result.data, with: Entities::V1::DealEntity)
        end

        desc '完成一笔还款交易', { headers: ApiRoot.auth_headers }
        patch :confirm_refund do
          result = DealService.new.confirm_refund(@voucher)
          return raise_error(result.error_id) unless result.success?

          present_ok(result.data, with: Entities::V1::DealEntity)
        end
      end # route_param
    end # resource

  end
end