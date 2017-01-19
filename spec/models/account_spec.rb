require 'rails_helper'

RSpec.describe Account, type: :model do
  describe '.create' do
    it 'when current is platform user' do
      account = create :account, account_type: 'platform'
      expect(account.pandore_id).not_to be_nil
      expect(account.pandore_id[0...2]).to eq('00')
    end

    it 'when current is common user' do
      account = create :account, account_type: 'common'
      expect(account.pandore_id).not_to be_nil
      expect(account.pandore_id[0...2]).to eq('01')
    end
  end
end
