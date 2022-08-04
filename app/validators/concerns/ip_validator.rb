class IpValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    valid = !begin
      IPAddr.new(value)
    rescue StandardError
      nil
    end.nil?
    record.errors.add(attribute, options[:message] || 'is not an IP') if valid
  end
end
