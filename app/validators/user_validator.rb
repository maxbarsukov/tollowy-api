module UserValidator
  extend ApplicationValidator

  validator do
    validates :email,
              length: { maximum: 50 },
              uniqueness: true,
              format: { with: URI::MailTo::EMAIL_REGEXP },
              presence: true

    validates :username,
              length: { maximum: 25 },
              uniqueness: true,
              format: { with: /
                      \A(?!.?(id\d)|[\d.]+)
                      (?!.*(\.\.|__))
                      (?!.*(\._|_\.))
                      (?!\.|_)
                      (?!.*(\.|_)$)
                      (?!\d+$)[a-zA-Z0-9._]{5,25}\z
              /x },
              presence: true

    validates :password,
              password_format: true,
              length: { maximum: ActiveModel::SecurePassword::MAX_PASSWORD_LENGTH_ALLOWED },
              allow_nil: true,
              allow_blank: true
  end
end
