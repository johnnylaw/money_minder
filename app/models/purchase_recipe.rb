require 'acts_as_transaction_recipe'

class PurchaseRecipe < ActiveRecord::Base
  acts_as_transaction_recipe
  
  class Error < StandardError; end
  
  has_many    :expected_purchases, :foreign_key => :transaction_recipe_id
  belongs_to  :vendor
  has_many    :virtual_portions, :class_name => 'PurchaseRecipeVirtualPortion'
  
  validates   :vendor, :existing_record => true, :allow_nil => true
  
  def vendor_name
    vendor && vendor.name || ''
  end
  
  def virtual_account
    virtual_accounts.first
  end

end