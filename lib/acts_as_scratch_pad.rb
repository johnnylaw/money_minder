require 'date_ext'

module ActsAsTransactionRecipe

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

  class SchedulingError < StandardError; end
  include DateConstants
  
  belongs_to  :spill_over_virtual_account, :class_name => 'VirtualAccount'
  has_many    :virtual_accounts, :through => :virtual_portions
  belongs_to  :default_inside_account, :class_name => 'Account'
  # belongs_to  :outside_account, :class_name => 'PhysicalAccount'
  # has_many    :virtual_portions, :class_name => "#{to_s}VirtualPortion"
  # has_many    :upcoming_transactions
  # composed_of :money, :mapping => [ %w(amount amount)]
  
  validates_with ExistingRecordValidator, :spill_over_virtual_account => { :allow_nil => false }
  validates_with RegularTransactionOccursAtIntervalValidator
  validates :name, :presence => true, :uniqueness => true
  validates :starts_on, :presence => true
  validates :current_as_of_hours_prior, :numericality => { :integer_only => true }
  validates :cents, :numericality => { :integer_only => true }
  validates_with ExistingRecordValidator, :default_inside_account => { :allow_nil => false }
  # validates_with ExistingRecordValidator, :outside_account => { :allow_nil => true }
  # validates_associated :virtual_portions
  
  def schedule(options = {})
    raise(SchedulingError, "Could not schedule #{rp.name}; desription invalid") unless self.valid?
    @max_scheduled_date_in_this_run = max_scheduled_out_to
    
    scheduling_days.each do |day|
      schedule_date = self.starts_on.the_next(day)  # Important for bi-weekly/bi-monthly tasks

      while schedule_date < should_schedule_until
        if should_schedule_this_date_given_these_options?(schedule_date, options) 
          UpcomingTransaction.find_or_create_by_regular_transaction_and_date_scheduled(self, schedule_date)
          @max_scheduled_date_in_this_run = schedule_date if @max_scheduled_date_in_this_run < schedule_date
        end
        schedule_date = schedule_date.the_next(day, :skip => num_of_intervals - 1)
      end
    end
    update_attribute(:max_scheduled_out_to, @max_scheduled_date_in_this_run)
  end
  
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
    @scheduling_hour, scheduling_day = self.occurs_at_or_on.split(/\s*on\s*/)
    @scheduling_days = (scheduling_day || 'day').split(',')
    @scheduling_hour = @scheduling_hour.to_i
    true
  end
    
  def should_schedule_until
    @should_schedule_until = nil if self.changes.present?
    return @should_schedule_until unless @should_schedule_until.nil?
    @should_schedule_until = Date.today + self.days_in_advance_to_schedule
    @should_schedule_until = [@should_schedule_until, self.ends_on].min if self.ends_on.is_a? Date
    @should_schedule_until
  end
end
