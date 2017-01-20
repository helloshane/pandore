FactoryGirl.define do
  factory :user do
    factory :debit_user do
      account { create :account }
    end

    factory :credit_user do
      account { create :account }
    end
  end
end