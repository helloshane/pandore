class DealService
  include ServiceResponse

  NoEnoughMoneyError = Class.new(StandardError)

  def register_loan(params)
    deal = nil
    tran_result = Deal.transaction do
      deal = Deal.create!({
        debit_user_id: params.debit_user_id,
        credit_user_id: params.credit_user_id,
        amount: params.amount
      })

      deal.vouchers.create(amount: params.amount, trade_type: 'loan')
    end

    return service_error(:create_loan_deal_fail) unless tran_result
    service_success(deal)
  end

  def register_refund(loan_deal)
    return service_error(:illegal_loan_deal_status) unless loan_deal.may_convert_to_finish_refund?

    tran_result = Deal.transaction do
      loan_deal.vouchers.create(amount: loan_deal.amount, trade_type: 'refund')
    end
    return service_error(:creatr_refund_deal_fail) unless tran_result
    service_success(loan_deal)
  end

  def confirm_loan(voucher)
    begin
      deal = voucher.deal
      capture_lock(deal) do
        deal.reload
        return service_error(:illegal_voucher_status) if voucher.finish?
        return service_error(:illegal_deal_status) unless deal.may_convert_to_finish_loan?

        tran_result = Deal.transaction do
          raise NoEnoughMoneyError if deal.loan_expense_account.amount <= voucher.amount

          voucher.expense_account.decrement!(:amount, deal.amount)
          voucher.income_account.increment!(:amount, deal.amount)
          voucher.finish!
          deal.convert_to_finish_loan!
        end
        return service_error(:confirm_loan_fail) unless tran_result
      end      
      service_success(deal)
    rescue NoEnoughMoneyError => e
      service_error(:no_enough_money)
    rescue Redis::Lock::LockTimeout => e
      service_error(:confirm_loan_fail)
    end
  end

  def confirm_refund(voucher)
    begin
      deal = voucher.deal
      capture_lock(deal) do
        deal.reload
        return service_error(:illegal_voucher_status) if voucher.finish?
        return service_error(:illegal_deal_status) unless deal.may_convert_to_finish_refund?

        tran_result = Deal.transaction do
          raise NoEnoughMoneyError if deal.refund_expense_account.amount <= voucher.amount

          voucher.expense_account.decrement!(:amount, deal.amount)
          voucher.income_account.increment!(:amount, deal.amount)
          voucher.finish!
          deal.convert_to_finish_refund!
        end
        return service_error(:confirm_refund_fail) unless tran_result
      end
      service_success(deal)
    rescue NoEnoughMoneyError => e
      service_error(:no_enough_money)
    rescue Redis::Lock::LockTimeout => e
      service_error(:confirm_refund_fail)
    end
  end

  def capture_lock(deal)
    # expiration unit is second
    Redis::Lock.new("deal:#{deal.deal_code}", :expiration => 0.5, :timeout => 0.1).lock { yield }
  end

end