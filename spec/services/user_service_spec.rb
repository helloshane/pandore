require 'rails_helper'

describe UserService do
  let(:spec_params) { Hashie::Mash.new(amount: 1.0) }

  it 'when success register' do
    expect(User.all.size).to eq(0)
    expect(Account.all.size).to eq(0)

    UserService.new.register(spec_params)

    expect(User.all.size).to eq(1)
    expect(Account.all.size).to eq(1)
  end

  it 'when fail register' do
    allow(Account).to receive(:create!).and_raise(ActiveRecord::Rollback)

    expect(User.all.size).to eq(0)
    expect(Account.all.size).to eq(0)

    UserService.new.register(spec_params)

    expect(User.all.size).to eq(0)
    expect(Account.all.size).to eq(0)
  end
end
