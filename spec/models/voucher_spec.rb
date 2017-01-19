require 'rails_helper'

RSpec.describe Deal, type: :model do
  describe '.create' do
    let(:spec_deal) { create :deal }
    let(:spec_voucher) { create :voucher, deal: spec_deal, trade_type: 'loan' }

    it 'when create' do
      expect(spec_voucher.voucher_code).not_to be_nil
      expect(spec_voucher.deal_code).not_to be_nil
      expect(spec_voucher.income_user_id).to eq(spec_voucher.deal.debit_user_id)
      expect(spec_voucher.expense_user_id).to eq(spec_voucher.deal.credit_user_id)
    end

    it 'when create loan voucher' do
      voucher = spec_deal.vouchers.create(trade_type: 'loan')
      expect(voucher.income_user_id).to eq(spec_deal.debit_user_id)
      expect(voucher.expense_user_id).to eq(spec_deal.credit_user_id)
    end

    it 'when create refund voucher' do
      voucher = spec_deal.vouchers.create(trade_type: 'refund')
      expect(voucher.income_user_id).to eq(spec_deal.credit_user_id)
      expect(voucher.expense_user_id).to eq(spec_deal.debit_user_id)
    end
  end
end