require 'date_ext'

module ActsAsTransactionRecipe
  class SchedulingError < StandardError; end

  module DateConstants
    WEEKDAY_REGEXP      = '((mon|tues|thurs|fri|satur|sun)(day)?|tue|wed|thu|sat|wednesday)'
    HOUR_REGEXP         = '(0|[01]?[0-9]|2[0-3])'
    DAY_OF_MONTH_REGEXP = '([0-2]?[0-9]|3[01])'
    MONTH_REGEXP        = '(0?[1-9]|1[0-2])'
    OKAY_REGEXP = {
      'day'     => Regexp.new("^#{HOUR_REGEXP}$"),
      'week'    => Regexp.new("^#{HOUR_REGEXP} on (#{WEEKDAY_REGEXP},)*#{WEEKDAY_REGEXP}$"),
      'month'   => Regexp.new("^#{HOUR_REGEXP} on (#{DAY_OF_MONTH_REGEXP},)*#{DAY_OF_MONTH_REGEXP}$"),
      'year'    => Regexp.new("^#{HOUR_REGEXP} on #{MONTH_REGEXP}\/#{DAY_OF_MONTH_REGEXP}$")
    }
  end
  
  module ActiveRecordBaseExt
    def acts_as_transaction_recipe
      send(:include, ActsAsTransactionRecipe)
    end
  end
  
  def self.included(base)
    base.class_eval do
      include ActsAsTransactionRecipe::DateConstants
  
      belongs_to  :spill_over_virtual_account, :class_name => 'VirtualAccount'
      has_many    :virtual_accounts, :through => :virtual_portions
      belongs_to  :default_inside_account, :class_name => 'Account'
      
      def self.find_or_create_by_name(attrs)
        result = find_by_name(attrs[:name])
        return result unless result.nil?

        vendor = attrs.delete(:vendor)
        customer = attrs.delete(:customer)
        virtual_account = attrs.delete(:virtual_account)
        raise('Must supply virtual account') if virtual_account.nil?

        result = new(attrs)
        result.vendor = vendor if result.respond_to? :vendor=
        result.customer = customer if result.respond_to? :customer=
        result.virtual_portions.build(
          :virtual_account => virtual_account, :cents => result.cents
        )
        result.save!
        result
      end
      
      def virtual_portions=(arr)
        raise ArgumentError unless arr.is_a? Array
        arr.each do |arg|
          self.virtual_portions.build(arg) and arg = nil if arg.is_a? Hash
          self.virtual_portions << arg and arg = nil if arg.is_a? PurchaseRecipeVirtualPortion
          self.virtual_portions << arg and arg = nil if arg.is_a? RevenueRecipeVirtualPortion
          raise ArgumentError(arg) unless arg.nil?
        end
        self.virtual_portions
      end
      

    end
  end
  
  def schedule
    recipe_class = "Expected#{self.class.to_s.sub(/Recipe$/, '')}".constantize

    @max_scheduled_time_in_this_run = max_scheduled_out_to
    
    scheduling_days.each do |day|
      next_date_to_look_for = self.starts_on.the_next(day, :include_self => true)
      max_time_needed_to_schedule_now = Time.now + self.current_as_of_hours_prior
      
      # Skip past last date that scheduling was done
      while scheduling_time(next_date_to_look_for) <= max_scheduled_out_to
        next_date_to_look_for = next_date_to_look_for.the_next(day, :skip => num_of_intervals - 1)
      end
      
      while (time = scheduling_time(next_date_to_look_for)) <= last_time_to_schedule_for_now
        recipe_class.find_or_create_by_recipe_and_date(self, next_date_to_look_for)
        @max_scheduled_time_in_this_run = [@max_scheduled_time_in_this_run, time].max
        next_date_to_look_for = next_date_to_look_for.the_next(day, :skip => num_of_intervals - 1)
      end
    end
    update_attribute(:max_scheduled_out_to, @max_scheduled_time_in_this_run)
  end
  
  def last_time_to_schedule_for_now
    Time.now + current_as_of_hours_prior.hours
  end
  
  def scheduling_time(date)
    date.to_time + scheduling_hour
  end
  
  # def schedule(options = {})
  #   # raise(SchedulingError, "Could not schedule #{self.name}; desription invalid") unless self.valid?
  #   @max_scheduled_date_in_this_run = max_scheduled_out_to
  #   scheduling_days.each do |day|
  #     schedule_date = self.starts_on.the_next(day)  # Important for bi-weekly/bi-monthly tasks
  #     while schedule_date < max_scheduled_out_to
  #       schedule_date = schedule_date.the_next(day, :skip => num_of_intervals - 1)
  #     end
  #     while schedule_date < should_schedule_until
  #       if should_schedule_this_date_given_these_options?(schedule_date, options) 
  #         ExpectedPurchase.find_or_create_by_recipe_and_date(self, schedule_date)
  #         # OR ExpectedRevenue.find_or_create_by_recipe_and_date(self, schedule_date)
  #         @max_scheduled_date_in_this_run = schedule_date if @max_scheduled_date_in_this_run < schedule_date
  #       end
  #       schedule_date = schedule_date.the_next(day, :skip => num_of_intervals - 1)
  #     end
  #   end
  #   update_attribute(:max_scheduled_out_to, @max_scheduled_date_in_this_run)
  # end
  
  def hour
    scheduling_hour
  end
  
  def should_schedule_this_date_given_these_options?(schedule_date, options)
    schedule_date > max_scheduled_out_to
  end
  
  private
    
  def scheduling_hour
    return @scheduling_hour unless @scheduling_hour.nil? || self.changes.present?
    set_scheduling_hour_and_day
    @scheduling_hour
  end
  
  def scheduling_days
    return @scheduling_days unless @scheduling_days.nil? || self.changes.present?
    set_scheduling_hour_and_day
    @scheduling_days
  end
  
  def set_scheduling_hour_and_day
    @scheduling_hour, scheduling_day_info = self.occurs_at.split(/\s+on\s+/)
    @scheduling_days = (scheduling_day_info || 'day').split(',')
    @scheduling_hour = @scheduling_hour.to_i
    true
  end
    
  def should_schedule_until
    @should_schedule_until = nil if self.changes.present?
    return @should_schedule_until unless @should_schedule_until.nil?
    @should_schedule_until = Date.today # TODO: Add scope; won't pertain to "schedule" but to "pencil in"
    @should_schedule_until = [@should_schedule_until, self.ends_on].min if self.ends_on.is_a? Date
    @should_schedule_until
  end

end

ActiveRecord::Base.send(:extend, ActsAsTransactionRecipe::ActiveRecordBaseExt)