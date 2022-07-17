class UrlValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.blank?

    url = if !value.start_with?('http://') && !value.start_with?('https://')
            "https://#{value}"
          else
            value.to_s
          end

    is_uri = (url =~ /\A#{URI::DEFAULT_PARSER.make_regexp(%w[http https])}\z/)
    record.errors.add(attribute, options[:message] || 'is not an url') if is_uri.nil?
  end
end
