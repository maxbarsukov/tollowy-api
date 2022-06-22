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
              exclusion: {
                in: ReservedWords.all,
                message: proc { I18n.t('models.user.username_is_reserved') }
              },
              presence: true

    validates :username, uniqueness: {
      case_sensitive: false,
      message: lambda do |_obj, data|
        I18n.t('models.user.is_taken', username: (data[:value]))
      end
    }, if: :username_changed?

    validates :password,
              password_format: true,
              length: { maximum: ActiveModel::SecurePassword::MAX_PASSWORD_LENGTH_ALLOWED },
              allow_nil: true,
              allow_blank: true

    validates :password_digest,
              presence: true

    validates :sign_in_count, presence: true

    validates_presence_of :posts_count, :comments_count
  end
end
