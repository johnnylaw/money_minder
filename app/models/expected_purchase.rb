require 'acts_as_expected_transaction'

class ExpectedPurchase < ActiveRecord::Base
  acts_as_expected_transaction
  belongs_to  :recipe, :class_name => 'PurchaseRecipe', :foreign_key => :transaction_recipe_id
  has_one     :purchase
  
  scope :outstanding, joins('LEFT OUTER JOIN purchases p ON p.expected_purchase_id=expected_purchases.id').
                      where('p.expected_purchase_id is null').
                      where(:is_complete => false)
  
  def status
    return 'completed' unless purchase.nil?
    return 'dismissed' if is_complete?
    recipe.is_promised? && outstanding? && Date.today > scheduled_on - 4.days && 'danger' || 'okay'
  end
  
  def outstanding?
    !is_complete? && purchase.nil?
  end
  
  def virtual_account
    recipe.virtual_accounts && recipe.virtual_accounts.first
  end
end