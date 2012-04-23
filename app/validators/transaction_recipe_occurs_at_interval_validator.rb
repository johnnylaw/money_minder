class TransactionRecipeOccursAtIntervalValidator < ActiveModel::Validator
  include DateConstants
  def validate(record)
    intervals = OKAY_REGEXP.keys
    unless intervals.include? record.base_interval
      record.errors.add(:base_interval, "Must be in #{intervals.inspect}") and return
    end
    unless record.num_of_intervals.is_a?(Integer) && record.num_of_intervals > 0
      record.errors.add(:num_of_intervals, "Must be an integer > 0") and return 
    end
    if record.occurs_at_or_on.blank?
      record.errors.add(:occurs_at_or_on, 'must be present') and return
    end
    unless record.occurs_at_or_on.downcase.match(OKAY_REGEXP[record.base_interval])
      record.errors.add(:occurs_at_or_on, 'has invalid format')
    end
  end
end
