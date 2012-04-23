require 'acts_as_expected_transaction'

class ExpectedPurchase < ActiveRecord::Base
  acts_as_expected_transaction
  belongs_to  :recipe, :class_name => 'PurchaseRecipe', :foreign_key => :transaction_recipe_id
  
end