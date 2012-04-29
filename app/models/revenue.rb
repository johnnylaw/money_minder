class Revenue < ActiveRecord::Base
  belongs_to  :account_to, :class_name => 'Account'
  belongs_to  :customer
  has_many    :virtual_revenues
  belongs_to  :expected_revenue
  
  accepts_nested_attributes_for :virtual_revenues
  before_save :process_expected_revenue, :if => proc { |p| p.expected_revenue_id }
  before_save :process_revenue
  
  scope     :to_account,    lambda{ |acct| where(:account_to_id => acct.id) }
  
  def initialize(*args)
    super
    self.executed_at ||= Time.now
  end
  
  def self.new_from_expected_revenue(exp_rev)
    revenue = new(:expected_revenue => exp_rev)
    revenue.account_to = exp_rev.recipe.default_inside_account
    revenue.memo = exp_rev.recipe.name
    revenue.amount = exp_rev.recipe.amount
    revenue.customer = exp_rev.recipe.customer
    revenue.build_virtual_revenues
    revenue
  end
  
  def amount=(arg)
    @amount = Money.from_string(arg.to_f.to_s)
  end
  
  def amount
    @amount ||= virtual_revenues.sum(&:amount)
  end
  
  def build_virtual_revenues
    expected_revenue.recipe.virtual_portions.each do |virtual_portion|
      self.virtual_revenues.build(:account_to => virtual_portion.virtual_account, :cents => virtual_portion.cents)
    end
    expected_revenue.unused_virtual_accounts.each do |virtual_account|
      self.virtual_revenues.build(:account_to => virtual_account, :cents => 0)
    end
  end
  
  def spill_over_virtual_revenue
    remaining_cents = expected_revenue.recipe.cents - expected_revenue.recipe.virtual_portions.sum(:cents)
    VirtualRevenue.new(:account_to => expected_revenue.recipe.spill_over_virtual_account, :cents => remaining_cents)
  end
    
  def process_expected_revenue
    expected_revenue.recipe.virtual_portions.each do |virtual_portion|
      self.virtual_revenues = self.virtual_revenues.select{ |vr| vr.amount > Money.new(0) }
      virtual_amounts = virtual_revenues.map(&:amount).sum
      if (overage = amount - virtual_amounts ) > Money.new(0)
        add_amount_to_spill_over_virtual_revenue(overage)
      end
    end
  end
  
  def process_revenue
    self.virtual_revenues = self.virtual_revenues.select{ |vr| vr.amount > Money.new(0) }
  end
  
  def add_amount_to_spill_over_virtual_revenue(overage)
    find_or_build_spill_over_virtual_revenue.amount += overage
  end
  
  # Assumes that expected_revenue exists
  def find_or_build_spill_over_virtual_revenue
    spill_over_account = expected_revenue.recipe.spill_over_virtual_account
    
    virtual_revenues.select{ |vp| vp.account_to == spill_over_account }.first ||
      virtual_revenues.build(:account_to => spill_over_account, :amount => 0)
  end
  
end