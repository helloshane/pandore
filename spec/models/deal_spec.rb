require 'rails_helper'

RSpec.describe Deal, type: :model do
  let(:spec_deal) { create :deal }

  describe '.create' do
    it 'when create' do
      expect(spec_deal).not_to be_nil
      expect(spec_deal.status).to eq('init')
    end
  end

  describe 'status change' do
    it 'when change to finish_loan' do
      expect(spec_deal.loaned_at).to be_nil

      spec_deal.convert_to_finish_loan!
      expect(spec_deal.status).to eq('finish_loan')
      expect(spec_deal.loaned_at).not_to be_nil
    end

    it 'when change to finish_refund' do
      spec_deal.finish_loan!
      expect(spec_deal.refunded_at).to be_nil

      spec_deal.convert_to_finish_refund
      expect(spec_deal.status).to eq('finish_refund')
      expect(spec_deal.refunded_at).not_to be_nil
    end
  end
end
