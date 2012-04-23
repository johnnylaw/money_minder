class Purchase < ActiveRecord::Base
  belongs_to  :vendor, :autosave => true
  belongs_to  :account_from, :class_name => 'Account'
  has_many    :virtual_purchases
  
  accepts_nested_attributes_for :virtual_purchases
  
  scope     :from_account, lambda{ |acct| where(:account_from_id => acct.id) }
  
  def self.new_from_virtual_account_id(virtual_account_id)
    new_from_virtual_account(VirtualAccount.find_by_id(virtual_account_id))
  end
  
  def self.new_from_virtual_account(virtual_account)
    purchase = new
    purchase.virtual_transactions.build( :account_from => virtual_account )
    purchase
  end

  def self.new_for_expected_purchase(expected_purchase)
    purchase = new(:vendor => expected_purchase.recipe.vendor)
                    
    purchase.virtual_purchases.build( :account_from => expected_purchase.recipe.virtual_accounts.first,
                                      :cents => expected_purchase.recipe.cents )
    purchase
  end
  
  def initialize(*args)
    super
    self.executed_at ||= Time.now
  end
  
  def vendor_name
    vendor && vendor.name || ''
  end
  
  def vendor_name=(name)
    self.vendor = Vendor.find_by_name(name) || Vendor.new(:name => name)
  end
  
  def amount
    virtual_purchases.map(&:cents).sum
  end
end