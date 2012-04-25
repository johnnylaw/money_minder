class ExistingRecordValidator < ActiveModel::Validator
  def validate(record)
    options[:attributes].each do |assoc|
      foreign_key = options[:foreign_key] || "#{assoc}_id".to_sym
      allow_nil = options[:allow_nil] || false
      unless record.send(foreign_key).nil? && allow_nil
        record.errors.add(assoc, "Invalid #{assoc.to_s.gsub('_', ' ')}") if record.send(assoc).nil?
      end
    end
  end
end
