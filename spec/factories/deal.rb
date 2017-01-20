FactoryGirl.define do
  factory :deal do
    amount 1.0
    debit_user_id { (create :debit_user).id }
    credit_user_id { (create :credit_user).id }

    factory :deal_finish_loan do
      # debit_user_id { (create :user).id }
      # credit_user_id { (create :user).id }

      after(:create) { |obj| obj.finish_loan! }
    end
  end
end