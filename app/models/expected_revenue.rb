require 'acts_as_expected_transaction'

class ExpectedRevenue < ActiveRecord::Base
  acts_as_expected_transaction
  belongs_to  :recipe, :class_name => 'RevenueRecipe', :foreign_key => :transaction_recipe_id
  
end