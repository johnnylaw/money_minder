namespace :db do
  desc 'populate database with account information'
  task :populate => :environment do
    Rake::Task['db:populate_account_info'].invoke
  end
  
  def find_or_make_account(name, type)
    type = [type].flatten
    acct = Account.find_or_create_by_name(
      :name => name, :is_spending => type.include?(:spending), :is_holding => type.include?(:holding)
    )
    raise "Could not make '#{name}' account" unless acct.id
    puts "Found or made '#{name}' account"
    acct
  end
  
  def find_or_make_virtual_account(name, primary_spending_acct)
    acct = VirtualAccount.find_or_create_by_name(
      :name => name, :primary_spending_account => primary_spending_acct
    )
    raise "Could not make '#{name}' VIRTUAL account" unless acct.id
    puts "Found or made '#{name}' VIRTUAL account"
    acct
  end
  
  task :populate_account_info => :environment do
    savings = find_or_make_account('USAA Savings', :holding)
    checking = find_or_make_account('USAA Checking', [:holding, :spending])
    visa = find_or_make_account('REI Visa', :spending)
    cash = find_or_make_account('Cash', [:spending, :holding])
    investment = find_or_make_account('Investment', :holding)

    discretionary = find_or_make_virtual_account('Discretionary', visa)
    gifts         = find_or_make_virtual_account('Gifts', visa)
    phone         = find_or_make_virtual_account('Phone', checking)
    electricity   = find_or_make_virtual_account('Electricity', visa)
    gas           = find_or_make_virtual_account('Gas', visa)
    clothing      = find_or_make_virtual_account('Clothing', visa)
    travel        = find_or_make_virtual_account('Travel', visa)
    household     = find_or_make_virtual_account('Household', visa)
    toys          = find_or_make_virtual_account('Toys', visa)
    food          = find_or_make_virtual_account('Food', visa)
    fixed         = find_or_make_virtual_account('Fixed Expenses', checking)
    invest_v_acct = find_or_make_virtual_account('Investment', investment)
    transportation= find_or_make_virtual_account('Transportation', visa)
    emergency     = find_or_make_virtual_account('Emergency', visa)
    hygeine       = find_or_make_virtual_account('Hygeine', visa)
    charity       = find_or_make_virtual_account('Charity', visa)
    relocation    = find_or_make_virtual_account('Relocation', visa)

    puts "Making ShopKeep (customer)"
    (shopkeep = Customer.find_or_create_by_name('ShopKeep.com, LLC')).id || raise('ShopKeep')
    
    puts "Planning 'breakfast' regular purchase"
    breakfast = PurchaseRecipe.find_or_create_by_name(
      :name => 'Breakfast',
      :virtual_account => food, 
      :spill_over_virtual_account => discretionary,
      :default_inside_account => visa,
      :occurs_at => '10 on mon,tue,wed,thu,fri',
      :base_interval => 'week',
      :is_promised => false,
      :current_as_of_hours_prior => 10,
      :cents => '400',
      :starts_on => Date.parse('2012-03-15'))
    breakfast.id || raise('Breakfast')
    
    puts "Planning Brunch regular purchase"
    brunch = PurchaseRecipe.find_or_create_by_name(
      :name => 'Brunch',
      :virtual_account => food, 
      :spill_over_virtual_account => discretionary,
      :default_inside_account => visa,
      :occurs_at => '10 on sat,sun',
      :base_interval => 'week',
      :is_promised => false,
      :current_as_of_hours_prior => 10,
      :cents => '1400',
      :starts_on => Date.parse('2012-03-15')
    )
    brunch.id || raise('Brunch')
    
    puts "Planning 'lunch' regular purchase"
    lunch = PurchaseRecipe.find_or_create_by_name(
      :name => 'Lunch',
      :virtual_account => food,
      :default_inside_account => visa,
      :spill_over_virtual_account => discretionary,
      :occurs_at => '14 on mon,tue,wed,thu,fri',
      :base_interval => 'week',
      :is_promised => false,
      :current_as_of_hours_prior => 8,
      :cents => '1000',
      :starts_on => Date.parse('2012-03-15'))
    lunch.id || raise('Lunch')
    
    puts "Planning 'dinner' regular purchase"
    dinner = PurchaseRecipe.find_or_create_by_name(
      :name => 'Dinner',
      :virtual_account => food, 
      :spill_over_virtual_account => discretionary,
      :default_inside_account => visa,
      :occurs_at => '18:00',
      :base_interval => 'day',
      :is_promised => false,
      :current_as_of_hours_prior => 13,
      :cents => '1500',
      :starts_on => Date.parse('2012-03-15'))
    dinner.id || raise('Dinner')
    
    puts "Planning 'snack' regular purchase"
    snack = PurchaseRecipe.find_or_create_by_name(
      :name => 'Snack',
      :virtual_account => food, 
      :default_inside_account => visa,
      :spill_over_virtual_account => discretionary,
      :occurs_at => '16:00',
      :base_interval => 'day',
      :is_promised => false,
      :current_as_of_hours_prior => 11,
      :cents => '100',
      :starts_on => Date.parse('2012-03-15'))
    snack.id || raise('Snack')
    
    puts "Planning 'rent' regular purchase"
    PurchaseRecipe.find_or_create_by_name(
      :name => 'Rent',
      :virtual_account => fixed, 
      :default_inside_account => checking,
      :spill_over_virtual_account => nil,
      :occurs_at => '8 on 1',
      :vendor   => Vendor.find_or_create_by_name('Justin HC, LLC'),
      :base_interval => 'month',
      :is_promised => true,
      :current_as_of_hours_prior => 168,
      :cents => '157500',
      :starts_on => Date.parse('2012-03-15')
    ).id || raise('Rent Regular Purchase')
    
    puts "Planning 'Cell Phone' regular purchase"
    PurchaseRecipe.find_or_create_by_name(
      :name => 'Phone',
      :virtual_account => phone, 
      :default_inside_account => visa,
      :spill_over_virtual_account => nil,
      :occurs_at => '8 on 5',
      :vendor   => Vendor.find_or_create_by_name('Verizon Wireless'),
      :base_interval => 'month',
      :is_promised => true,
      :current_as_of_hours_prior => 168,
      :cents => '9500',
      :starts_on => Date.parse('2012-04-15')
    ).id || raise('Phone Reg Purchase')
    
    puts "Planning Pay from Shopkeep"
    paycheck_name = 'ShopKeep Paycheck'
    unless RevenueRecipe.find_by_name(paycheck_name)
      RevenueRecipe.create(
        :name => paycheck_name,
        :virtual_portions => [
          { :virtual_account => invest_v_acct, :cents => '30000' },
          { :virtual_account => fixed, :cents => '100847' },
          { :virtual_account => electricity, :cents => '4154' },
          { :virtual_account => gas, :cents => '2308' },
          { :virtual_account => phone, :cents => '4385' },
          { :virtual_account => clothing, :cents => '8000' },
          { :virtual_account => travel, :cents => '12500' },
          { :virtual_account => household, :cents => '2500' },
          { :virtual_account => emergency, :cents => '2500' },
          { :virtual_account => hygeine, :cents => '4000' },
          { :virtual_account => gifts, :cents => '3000' },
          { :virtual_account => charity, :cents => '3000' },
          { :virtual_account => food, :cents => '42000' },
          { :virtual_account => toys, :cents => '7000' },
        ],
        :spill_over_virtual_account => discretionary,
        :customer => shopkeep,
        :default_inside_account => checking,
        :occurs_at => '8 on Wednesday',
        :base_interval => 'week',
        :num_of_intervals => 2,
        :starts_on => '2012-03-28',
        :is_promised => true,
        :current_as_of_hours_prior => 24,
        :cents => '274500'
      ).id || raise('ShopKeep Paycheck')
    end

    make_bday = lambda { |name, date, amt|
      rp = PurchaseRecipe.find_or_create_by_name(
        :name => "#{name}'s Birthday",
        :virtual_account => gifts, 
        :default_inside_account => visa,
        :spill_over_virtual_account => discretionary,
        :occurs_at => "8 on #{date}",
        :vendor   => nil,
        :base_interval => 'year',
        :is_promised => false,
        :current_as_of_hours_prior => 336,
        :cents => amt.to_s,
        :starts_on => Date.today
      )
      rp.id || raise("Couldn't make #{name}'s bday purchase")
      puts "Made or found #{name}'s birthday"
      return rp
    }
    
    make_bday.call('Leslie', '5/7', 7500)
    make_bday.call('Evelyn', '9/29', 4500)
    make_bday.call('Dad', '9/5', 4000)
    make_bday.call('Mom', '1/6', 4000)
    make_bday.call('Ben', '7/6', 4000)
    make_bday.call('Gaby', '6/6', 4000)
    make_bday.call('Jessica', '12/10', 4000)
    make_bday.call('Forest', '10/22', 500)
    make_bday.call('Zac', '11/25', 4000)
    # make_bday('Nathan', '3/14', 40)
    # make_bday('Amber', '')
    make_bday.call('Ibrahim', '7/21', 4000)


    puts "Cooking all Purchase Recipes"
    PurchaseRecipe.all.map{ |r| r.schedule }
    puts "complete all purchase recipes"
    
    puts "Cooking all Revenue Recipes"
    RevenueRecipe.all.map{ |r| r.schedule }
    
    # (QuickTransfer.find_or_create_by_name(
    #   :name => 'Swipe',
    #   :virtual_account_to => transportation,
    #   :cents => '210'  
    # )).id || raise('Subway')
  end
  

end
