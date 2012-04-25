class Purchase < ActiveRecord::Base
  belongs_to  :vendor, :autosave => true, :validate => true
  belongs_to  :account_from, :class_name => 'Account'
  belongs_to  :expected_purchase
  has_many    :virtual_purchases
  
  accepts_nested_attributes_for :virtual_purchases
  before_save :process_expected_purchase, :if => proc { |p| p.expected_purchase_id }
  
  scope     :from_account, lambda{ |acct| where(:account_from_id => acct.id) }
  
  validates :vendor, :account_from, :existing_record => true, :allow_nil => false
  
  def self.new_from_virtual_account_id(virtual_account_id)
    new_from_virtual_account(VirtualAccount.find_by_id(virtual_account_id))
  end
  
  def self.new_from_virtual_account(virtual_account)
    purchase = new
    purchase.virtual_purchases.build( :account_from => virtual_account )
    purchase
  end

  def self.new_from_expected_purchase(expected_purchase)
    purchase = new(:expected_purchase => expected_purchase)
    purchase.memo = expected_purchase.recipe.name
    purchase.vendor = expected_purchase.recipe.vendor
    purchase.build_virtual_purchase
    purchase
  end
  
  def initialize(*args)
    super
    self.executed_at ||= Time.now
  end
  
  def build_virtual_purchase
    account_from = expected_purchase && expected_purchase.recipe.virtual_account
    cents = expected_purchase && expected_purchase.recipe.cents
    virtual_purchases.build(:account_from => account_from, :cents => cents)
  end
  
  def vendor_name
    vendor && vendor.name || ''
  end
  
  def vendor_name=(name)
    self.vendor = Vendor.find_or_initialize_by_name(name)
  end
  
  def amount
    virtual_purchases.map(&:amount).sum
  end
  
  private
  
  def process_expected_purchase
    expected_purchase.recipe.virtual_portions.each do |virtual_portion|
      corresponding_virtual_purchases = virtual_purchases.select{ |vp| vp.account_from == virtual_portion.virtual_account }
      approved_amount = virtual_portion.amount    
      actual_amount = corresponding_virtual_purchases.map(&:amount).sum
      if (overage = actual_amount - approved_amount ) > Money.new(0)
        add_amount_to_spill_over_virtual_purchase(overage)
        subtract_amount_from_corresponding_virtual_purchase(overage, corresponding_virtual_purchases.first)
      end
    end
  end
  
  def add_amount_to_spill_over_virtual_purchase(overage)
    find_or_build_spill_over_virtual_purchase.amount += overage
  end
  
  def subtract_amount_from_corresponding_virtual_purchase(overage, vpurch)
    vpurch.amount -= overage
  end
  
  # Assumes that expected_purchase exists
  def find_or_build_spill_over_virtual_purchase
    spill_over_account = expected_purchase.recipe.spill_over_virtual_account
    
    virtual_purchases.select{ |vp| vp.account_from == spill_over_account }.first ||
      virtual_purchases.build(:account_from => spill_over_account, :amount => 0)
  end
end