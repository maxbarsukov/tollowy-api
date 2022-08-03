class PasswordFormatValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless /
            (?=.*[0-9])
            (?=.*[a-z])
            (?=.*[A-Z])
            [0-9a-zA-Z!@#$%^&*)(\\+_\-]{6,}
          /x.match?(value)
      record.errors.add attribute, (options[:message] || I18n.t('errors.users.messages.password_must_contain'))
    end
  end
end
