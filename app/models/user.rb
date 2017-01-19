class User < ApplicationRecord
  belongs_to :account

  after_create :set_auth_token

  # 余额
  def money
    account.amount.to_f
  end

  # 借出记录
  def credit_deals
    Deal.finish_loan.where(credit_user_id: id)
  end

  def credit_deals_filter(other_id)
    credit_deals.where(debit_user_id: other_id)
  end

  def credit_deals_money
    credit_deals.sum(:amount).to_f
  end

  def credit_deals_filter_money(other_id)
    credit_deals_filter(other_id).sum(:amount).to_f
  end

  # 借入记录
  def debit_deals
    Deal.finish_loan.where(debit_user_id: id)
  end

  def debit_deals_filter(other_id)
    debit_deals.where(credit_user_id: other_id)
  end

  def debit_deals_money
    debit_deals.sum(:amount).to_f
  end

  def debit_deals_filter_money(other_id)
    debit_deals_filter(other_id).sum(:amount).to_f
  end

  private
  def set_auth_token
    salt = Rails.application.secrets.user_token_key
    token = OpenSSL::HMAC.hexdigest('sha1', salt, id.to_s)
    update(auth_token: token)
  end 

end
