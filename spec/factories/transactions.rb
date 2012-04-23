# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :transaction do
      vendor_id 1
      account_from_id 1
      accout_to_id 1
      customer_id 1
      memo "MyString"
      amount "9.99"
      executed_at "2012-04-22 10:51:50"
    end
end