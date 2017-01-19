class Voucher < ApplicationRecord
  belongs_to :deal

  after_create :full_voucher_data

  enum status: {
    init: 0,
    finish: 1
  }

  enum trade_type: {
    loan: 0,
    refund: 1
  }
  
  def income_account
    User.find(income_user_id).account
  end

  def expense_account
    User.find(expense_user_id).account
  end

  private
  def full_voucher_data
    attrs = {
      deal_id: deal.id,
      deal_code: deal.deal_code,
      status: 'init',
      voucher_code: gen_voucher_code
    }.merge(money_transfer_attrs)

    self.update(attrs)
  end

  def money_transfer_attrs
    return loan_direction if loan?
    return refund_direction if refund?
  end

  def loan_direction
    { income_user_id: deal.debit_user_id, expense_user_id: deal.credit_user_id }
  end

  def refund_direction
    { income_user_id: deal.credit_user_id, expense_user_id: deal.debit_user_id }
  end

  def gen_voucher_code
    voucher_code_prefix + voucher_code_middle + voucher_code_suffix
  end

  def voucher_code_prefix
    return loan_prefix if loan?
    return refund_prefix if refund?
  end

  def voucher_code_middle
    Time.now.strftime('%Y%m%d')
  end

  def voucher_code_suffix
    ScatterSwap.hash(id)
  end

  def loan_prefix
    '10'
  end

  def refund_prefix
    '20'
  end

end