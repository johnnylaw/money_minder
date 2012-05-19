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
            "be named XyzAccount or simply Account"
    end
    acctType = base.to_s.sub(/Account$/,'')
    acct_type = acctType.underscore
    
    base.class_eval do
      default_scope order(:name)
      
      validates :name, :presence => true, :uniqueness => true
      
      composed_of :initial_balance,
        :class_name => "Money",
        :mapping => [%w(initial_balance_in_cents cents)],
        :constructor => Proc.new { |cents| Money.new(cents || 0) },
        :converter => Proc.new { |value| value.respond_to?(:to_money) ? value.to_money : raise(ArgumentError, "Can't convert #{value.class} to Money") }
        
      # self.method_missing(*args)
      # This is solely for queries from console and can be removed when development slows
      def self.method_missing(*args)
        begin
          super
        rescue NoMethodError => e
          where('lower(name) = ?', args.first.to_s.underscore.gsub('_', ' ')).first || raise(e)
        end
      end
        
    end

  end
  
  def attributes
    super.merge('balance' => balance.dollars)
  end
  
  def to_json
    self.attributes.to_json
  end

  def to_param
    name
  end

end
ActiveRecord::Base.send(:extend, ActsAsAccount::ActiveRecordBaseExt)