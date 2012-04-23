# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :account do
      name "MyString"
      is_spending false
      is_holding false
      holding_account_id 1
    end
end