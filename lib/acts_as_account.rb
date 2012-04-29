require 'money'

module ActsAsAccount
  ZERO = Money.new(0)
  
  module ActiveRecordBaseExt
    def acts_as_account
      send(:include, ActsAsAccount)
    end
  end
  
  def self.included(base)
    unless base.to_s.match /^([A-Z][a-z]*)*Account$/
      raise "#{base.to_s} is not a valid class name. ActsAsAccount classes must " +
            "be named XyzAccount, where Xyz is not blank."
    end
    acctType = base.to_s.sub(/Account$/,'')
    acct_type = acctType.underscore
    
    base.class_eval do
      default_scope order(:name)
      
      validates :name, :presence => true, :uniqueness => true
    end

  end
  
  def attributes
    super.merge('balance' => balance)
  end
  
  def to_json
    self.attributes.to_json
  end

  def to_param
    name
  end

end
ActiveRecord::Base.send(:extend, ActsAsAccount::ActiveRecordBaseExt)