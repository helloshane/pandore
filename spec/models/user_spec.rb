require 'rails_helper'

RSpec.describe User, type: :model do
  describe '.create' do
    it 'when create' do
      user = create :user
      expect(user.auth_token).not_to be_nil
    end
  end

  describe 'debit' do
    let(:debit) { create :user, id: 1 }
    let(:credit) { create :user, id: 2 }
    before do
      deal = create :deal, debit_user_id: debit.id, credit_user_id: credit.id, amount: 1
      deal.finish_loan!
    end

    it '#debit_deals' do
      expect(debit.debit_deals.size).to eq(1)
    end

    it '#debit_deals_filter' do
      expect(debit.debit_deals_filter(2).size).to eq(1)
      expect(debit.debit_deals_filter(3).size).to eq(0)
    end

    it '#debit_deals_money' do
      expect(debit.debit_deals_money.to_f).to eq(1.0)
    end

    it '#debit_deals_filter_money' do
      expect(debit.debit_deals_filter_money(2).to_f).to eq(1.0)
      expect(debit.debit_deals_filter_money(3).to_f).to eq(0.0)
    end
  end

  describe 'credit' do
    let(:debit) { create :user, id: 1 }
    let(:credit) { create :user, id: 2 }
    before do
      deal = create :deal, debit_user_id: debit.id, credit_user_id: credit.id, amount: 1
      deal.finish_loan!
    end

    it '#credit_deals' do
      expect(credit.credit_deals.size).to eq(1)
    end

    it '#credit_deals_filter' do
      expect(credit.credit_deals_filter(1).size).to eq(1)
      expect(credit.credit_deals_filter(3).size).to eq(0)
    end

    it '#credit_deals_money' do
      expect(credit.credit_deals_money.to_f).to eq(1.0)
    end

    it '#credit_deals_filter_money' do
      expect(credit.credit_deals_filter_money(1).to_f).to eq(1.0)
      expect(credit.credit_deals_filter_money(3).to_f).to eq(0.0)
    end
  end
end
