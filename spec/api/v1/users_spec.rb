require 'rails_helper'

describe V1::Users do
  let(:error_resp) { Hashie::Mash.new(success?: false, error_id: :grape_validate_error!) }

  before do
    allow_any_instance_of(AuthHelpers).to receive(:authenticate!).and_return(true)
  end

  describe '用户注册' do
    it 'when success' do
      expect(User.all.size).to eq(0)

      post '/api/v1/users/register',params:  { amount: 100 }
      expect(json[:success]).to be_truthy
      expect(User.last.money).to eq(100.0)
    end

    it 'when fail' do
      allow_any_instance_of(UserService).to receive(:register).and_return(error_resp)

      expect(User.all.size).to eq(0)

      post '/api/v1/users/register', params: { amount: 100 }
      expect(json[:success]).to be_falsey
      expect(User.all.size).to eq(0)
    end
  end

  describe '账户情况查询' do
    let(:spec_account) { create :account, account_type: 'common', amount: 100 }
    let(:spec_user) { create :user, account: spec_account }
    it 'when sucess' do
      get "/api/v1/users/#{spec_user.id}/account_detail"
      expect(json[:success]).to be_truthy
      expect(json[:data][:balance]).to eq(100.0)
    end
  end

  describe '债务情况查询' do
    def seed_data
      accounts = create_list(:account, 2)
      user_a = create :user, account: accounts.first
      user_b = create :user, account: accounts.last

      [user_a.id, user_b.id]
    end

    it 'when success' do
      ids = seed_data
      get '/api/v1/users/debt_detail', params: { user_ids: ids.join(',') }
      expect(json[:success]).to be_truthy

      resp = json[:data].keys.map(&:to_s).sort
      raw = ids.map(&:to_s).sort
      expect(resp).to eq(raw)
    end
  end
end