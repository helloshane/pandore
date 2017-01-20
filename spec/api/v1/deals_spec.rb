require 'rails_helper'

describe V1::Deals do
  let(:debit_user) { create :user }
  let(:credit_user) { create :user }
  let(:deal_finish_loan) { create :deal_finish_loan }
  let(:voucher_loan_init) { create :voucher_loan_init }
  let(:voucher_refund_init) { create :voucher_refund_init }

  before do
    allow_any_instance_of(AuthHelpers).to receive(:authenticate!).and_return(true)
  end

  def error_resp(error_id)
    Hashie::Mash.new(success?: false, error_id: error_id)
  end

  describe '借款交易注册' do
    it 'when success' do
      expect(Deal.all.count).to eq(0)
      expect(Voucher.all.count).to eq(0)

      post '/api/v1/deals/loan_register',params:  { debit_user_id: debit_user.id, credit_user_id: credit_user.id, amount: 1.0 }

      expect(json[:success]).to be_truthy
      expect(Deal.all.count).to eq(1)
      expect(Voucher.all.count).to eq(1)
    end

    it 'when fail' do
      allow_any_instance_of(DealService).to receive(:register_loan).and_return(error_resp(:create_loan_deal_fail))

      expect(Deal.all.count).to eq(0)
      expect(Voucher.all.count).to eq(0)

      post '/api/v1/deals/loan_register',params:  { debit_user_id: debit_user.id, credit_user_id: credit_user.id, amount: 1.0 }

      expect(json[:success]).to be_falsey
      expect(Deal.all.count).to eq(0)
      expect(Voucher.all.count).to eq(0)
    end
  end

  describe '还款交易注册' do
    it 'when success' do
      expect(deal_finish_loan.refund_vouchers.size).to eq(0)

      post '/api/v1/deals/refund_register', params: {  deal_code: deal_finish_loan.deal_code }

      expect(json[:success]).to be_truthy
      expect(deal_finish_loan.refund_vouchers.size).to eq(1)
    end

    it 'when fail' do
      allow_any_instance_of(DealService).to receive(:register_refund).and_return(error_resp(:creatr_refund_deal_fail))

      expect(deal_finish_loan.refund_vouchers.size).to eq(0)

      post '/api/v1/deals/refund_register', params: {  deal_code: deal_finish_loan.deal_code }

      expect(json[:success]).to be_falsey
      expect(deal_finish_loan.refund_vouchers.size).to eq(0)
    end
  end

  describe '完成一笔借款交易' do
    it 'when success' do
      expect(voucher_loan_init.status).to eq('init')
      expect(voucher_loan_init.deal.status).to eq('init')

      patch "/api/v1/deals/#{voucher_loan_init.voucher_code}/confirm_loan"

      voucher_loan_init.reload
      expect(json[:success]).to be_truthy
      expect(voucher_loan_init.status).to eq('finish')
      expect(voucher_loan_init.deal.status).to eq('finish_loan')
    end

    it 'when fail' do
      allow_any_instance_of(DealService).to receive(:confirm_loan).and_return(error_resp(:confirm_loan_fail))

      expect(voucher_loan_init.status).to eq('init')
      expect(voucher_loan_init.deal.status).to eq('init')

      patch "/api/v1/deals/#{voucher_loan_init.voucher_code}/confirm_loan"

      voucher_loan_init.reload
      expect(json[:success]).to be_falsey
      expect(voucher_loan_init.status).to eq('init')
      expect(voucher_loan_init.deal.status).to eq('init')
    end
  end

  describe '完成一笔还款交易' do
    it 'when success' do
      expect(voucher_refund_init.status).to eq('init')
      expect(voucher_refund_init.deal.status).to eq('finish_loan')

      patch "/api/v1/deals/#{voucher_refund_init.voucher_code}/confirm_refund"
      voucher_refund_init.reload
      expect(json[:success]).to be_truthy
      expect(voucher_refund_init.status).to eq('finish')
      expect(voucher_refund_init.deal.status).to eq('finish_refund')
    end

    it 'when fail' do
      allow_any_instance_of(DealService).to receive(:confirm_refund).and_return(error_resp(:confirm_refund_fail))

      expect(voucher_refund_init.status).to eq('init')
      expect(voucher_refund_init.deal.status).to eq('finish_loan')

      patch "/api/v1/deals/#{voucher_refund_init.voucher_code}/confirm_refund"
      voucher_refund_init.reload
      expect(json[:success]).to be_falsey
      expect(voucher_refund_init.status).to eq('init')
      expect(voucher_refund_init.deal.status).to eq('finish_loan')
    end
  end
end