FactoryGirl.define do
  factory :voucher do
    trait :finish_loan do
      deal { create :deal_finish_loan }
    end

    factory :voucher_loan_init do
      trade_type 'loan'
      deal { create :deal }
    end

    factory :voucher_refund_init do
      trade_type 'refund'
      deal { create :deal }

      after(:create) { |obj| obj.deal.finish_loan! }
    end

    factory :voucher_finish_loan, traits: [:finish_loan]
  end
end