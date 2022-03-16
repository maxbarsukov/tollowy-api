class PasswordFormatValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless /
            (?=.*[0-9])
            (?=.*[a-z])
            (?=.*[A-Z])
            [0-9a-zA-Z!@#$%^&*)(\\+_\-]{6,}
          /x.match?(value)
      record.errors.add attribute, (options[:message] || 'must contain Latin letters and numbers, ' \
                               'must be at least 6 characters, including a number, ' \
                               'an uppercase and a lowercase letters')
    end
  end
end
