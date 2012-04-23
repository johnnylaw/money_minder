module DateExt
  class FormattingError < StandardError; end
  
  WEEKDAYS = { :mo => 0, :tu => 1, :we => 2, :th => 3, :fr => 4, :sa => 5, :su => 6 }
  def self.included(base)
    base.extend(ClassMethods)
    base.send(:include, InstanceMethods)
  end
  
  module ClassMethods
  end
  
  module InstanceMethods
    def the_next(day, options = {})
      day = day.to_s
      skip = options.delete(:skip)
      return self.next if day.downcase == 'day'
      return the_next_with_skip_option(:next_with_day_of_week, day, skip, options) if day.match(/^[A-Za-z]{2,}$/)
      return the_next_with_skip_option(:next_with_day_of_month, day, skip, options) if day.match(/^[\d]{1,2}$/)
      return the_next_with_skip_option(:next_with_month_and_day, day, skip, options) if day.match(/^[\d]{1,2}(\/|\-)[\d]{1,2}$/)
      raise ArgumentError
    end
    
    def next_with_month_and_day(month_day, options = {})
      month, day = month_day.to_s.split(/\/|\-/)
      unless month.to_i.between?(1,12) && day.to_i.between?(1,31)
        raise FormattingError, 'Improperly formed date/month argument'
      end
      begin
        date = Date.parse("#{self.year}-#{month}-#{day}")
      rescue ArgumentError => e
        raise(FormattingError, e.message)
      end
      unless date > self
        date = date + 1.year unless date == self && options[:include_self]
      end
      date
    end
    
    def next_with_day_of_week(weekday, options = {})
      day = WEEKDAYS[weekday.to_s.downcase[0..1].to_sym]
      raise(FormattingError, "Bogus day of week: #{weekday}") if day.nil?
      added_days = (day - self.days_to_week_start) % 7
      result = self + added_days.days
      result = result + 1.week if result == self && !options[:include_self]
      result
    end
    
    def next_with_day_of_month(day_of_month, options = {})
      day = day_of_month.to_i
      raise(FormattingError, 'Day of month out of range') unless day.between? 1,31
      if self.day < day
        diff_between_days = (day - self.day).days
        result = [self + diff_between_days, self.end_of_month].min
      elsif self.day == day && options[:include_self]
        result = self
      else
        diff_between_days = (self.day - day).days
        result = self + 1.month
        result = [result - diff_between_days, result.beginning_of_month].max
      end
      result
    end
    
    private
    
    def the_next_with_skip_option(method_to_use, day, skip, options)
      result = self.send(method_to_use, day, options)
      unless options[:include_self]
        skip.to_i.times do 
          result = result.send(method_to_use, day, options)
        end
      end
      result
    end
  end
end

Date.send(:include, DateExt)