require 'rails_helper'

describe DealService do
  describe '#register_loan' do
    let(:spec_params) { Hashie::Mash.new(amount: 1.0, debit_user_id: 1, credit_user_id: 2) }

    it 'when success call' do
      expect(Deal.all.size).to eq(0)
      expect(Voucher.all.size).to eq(0)

      result = DealService.new.register_loan(spec_params)

      expect(Deal.all.size).to eq(1)
      expect(Voucher.all.size).to eq(1)
      expect(result.success?).to be_truthy
    end
  end

  describe '#refund_register' do
    let(:spec_deal) { create :deal }

    it 'when can not change to refund finish' do
      result = DealService.new.refund_register(spec_deal)
      expect(result.success?).to be_falsey
      expect(result.error_id).to eq(:illegal_loan_deal_status)
    end

    it 'when success call' do
      spec_deal.finish_loan!
      expect(spec_deal.refund_vouchers.size).to eq(0)

      result = DealService.new.refund_register(spec_deal)
      expect(result.success?).to be_truthy
      expect(spec_deal.refund_vouchers.size).to eq(1)
    end
  end

  describe '#confirm_loan' do
    let(:spec_debit_account) { create :account, amount: 1.0, account_type: 'common' }
    let(:spec_credit_account) { create :account, amount: 2.0, account_type: 'common' }
    let(:spec_debit_user) { create :user, account: spec_debit_account }
    let(:spec_credit_user) { create :user, account: spec_credit_account }
    let(:spec_deal) { create :deal, credit_user_id: spec_credit_user.id, debit_user_id: spec_debit_user.id }
    let(:spec_voucher) { create :voucher, deal: spec_deal, trade_type: 'loan' }

    it 'when voucher is finish' do
      spec_voucher.finish!

      result = DealService.new.confirm_loan(spec_voucher)
      expect(result.success?).to be_falsey
      expect(result.error_id).to eq(:illegal_voucher_status)
    end

    it 'when can not change to loan finish' do
      spec_voucher.deal.finish_loan!

      result = DealService.new.confirm_loan(spec_voucher)
      expect(result.success?).to be_falsey
      expect(result.error_id).to eq(:illegal_deal_status)
    end

    it 'when not enough money' do
      spec_voucher.expense_account.update(amount: 0)

      result = DealService.new.confirm_loan(spec_voucher)
      expect(result.success?).to be_falsey
      expect(result.error_id).to eq(:no_enough_money)
    end

    it 'when success call' do
      expect(spec_voucher.income_account.amount).to eq(1.0)
      expect(spec_voucher.expense_account.amount).to eq(2.0)

      result = DealService.new.confirm_loan(spec_voucher)

      expect(spec_voucher.income_account.amount).to eq(2.0)
      expect(spec_voucher.expense_account.amount).to eq(1.0)
      expect(result.success?).to be_truthy
    end

    it 'when fail call' do
      allow_any_instance_of(Deal).to receive(:convert_to_finish_loan!).and_raise(ActiveRecord::Rollback)

      expect(spec_voucher.income_account.amount).to eq(1.0)
      expect(spec_voucher.expense_account.amount).to eq(2.0)

      result = DealService.new.confirm_loan(spec_voucher)

      expect(spec_voucher.income_account.amount).to eq(1.0)
      expect(spec_voucher.expense_account.amount).to eq(2.0)
      expect(result.success?).to be_falsey
      expect(result.error_id).to eq(:confirm_loan_fail)
    end
  end

  describe '#confirm_refund' do
    let(:spec_debit_account) { create :account, amount: 2.0, account_type: 'common' }
    let(:spec_credit_account) { create :account, amount: 1.0, account_type: 'common' }
    let(:spec_debit_user) { create :user, account: spec_debit_account }
    let(:spec_credit_user) { create :user, account: spec_credit_account }
    let(:spec_deal) { create :deal, credit_user_id: spec_credit_user.id, debit_user_id: spec_debit_user.id }
    let(:spec_voucher) { create :voucher, deal: spec_deal, trade_type: 'refund' }

    it 'when voucher is finish' do
      spec_voucher.finish!

      result = DealService.new.confirm_refund(spec_voucher)
      expect(result.success?).to be_falsey
      expect(result.error_id).to eq(:illegal_voucher_status)
    end

    it 'when can not change to refund finish' do
      spec_voucher.deal.finish_refund!

      result = DealService.new.confirm_refund(spec_voucher)
      expect(result.success?).to be_falsey
      expect(result.error_id).to eq(:illegal_deal_status)
    end

    it 'when not enough money' do
      spec_voucher.deal.finish_loan!
      spec_voucher.expense_account.update(amount: 0)

      result = DealService.new.confirm_refund(spec_voucher)
      expect(result.success?).to be_falsey
      expect(result.error_id).to eq(:no_enough_money)
    end

    it 'when success call' do
      spec_voucher.deal.finish_loan!

      expect(spec_voucher.income_account.amount).to eq(1.0)
      expect(spec_voucher.expense_account.amount).to eq(2.0)

      result = DealService.new.confirm_refund(spec_voucher)

      expect(spec_voucher.income_account.amount).to eq(2.0)
      expect(spec_voucher.expense_account.amount).to eq(1.0)
      expect(result.success?).to be_truthy
    end

    it 'when fail call' do
      allow_any_instance_of(Deal).to receive(:convert_to_finish_refund!).and_raise(ActiveRecord::Rollback)
      spec_voucher.deal.finish_loan!

      expect(spec_voucher.income_account.amount).to eq(1.0)
      expect(spec_voucher.expense_account.amount).to eq(2.0)

      result = DealService.new.confirm_refund(spec_voucher)

      expect(spec_voucher.income_account.amount).to eq(1.0)
      expect(spec_voucher.expense_account.amount).to eq(2.0)
      expect(result.success?).to be_falsey
      expect(result.error_id).to eq(:confirm_refund_fail)
    end
  end
end