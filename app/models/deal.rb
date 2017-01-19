class Deal < ApplicationRecord
  include AASM

  has_many :vouchers

  before_create :init_default_values

  after_create :set_deal_code

  enum status: {
    init: 0,
    finish_loan: 1,
    finish_refund: 2
  }

  aasm :column => :status, :enum => true do
    state :init, initial: true
    state :finish_loan
    state :finish_refund

    event :convert_to_finish_loan do
      after { self.update(loaned_at: Time.now) }
      transitions :from => :init, :to => :finish_loan
    end

    event :convert_to_finish_refund do
      after { self.update(refunded_at: Time.now) }
      transitions :from => :finish_loan, :to => :finish_refund
    end
  end

  def loan_vouchers
    vouchers.loan
  end

  def refund_vouchers
    vouchers.refund
  end

  def loan_expense_account
    User.find(credit_user_id).account
  end

  def refund_expense_account
    User.find(debit_user_id).account
  end

  private
  def init_default_values
    self.status = 'init'
  end

  def set_deal_code
    update(deal_code: ScatterSwap.hash(id))
  end

end
