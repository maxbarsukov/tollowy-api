module UserValidator
  extend ApplicationValidator

  validator do
    validates :email,
              length: { maximum: 50 },
              uniqueness: true,
              format: { with: URI::MailTo::EMAIL_REGEXP },
              presence: true

    validates :username,
              length: { maximum: 50 },
              uniqueness: true,
              presence: true
  end
end
