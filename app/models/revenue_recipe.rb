require 'acts_as_transaction_recipe'

class RevenueRecipe < ActiveRecord::Base
  acts_as_transaction_recipe
  
  class Error < StandardError; end
  
  has_many    :expected_revenues, :foreign_key => :transaction_recipe_id
  belongs_to  :customer
  has_many    :virtual_portions, :class_name => 'RevenueRecipeVirtualPortion'
  belongs_to  :default_inside_account, :class_name => 'Account', :foreign_key => :default_inside_account_id
  
  # validates   :customer_id, :existing_record => true, :allow_nil => true

end