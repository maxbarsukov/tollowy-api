class Auth::AddMessage
  include Interactor

  delegate :existing_user,
           :new_email_passed,
           :login_by_existing_email,
           :user,
           :provider, to: :context

  def call
    context.message = generate_message
  end

  private

  def generate_message
    action = existing_user ? 'logged' : 'signed'

    msg = if login_by_existing_email
            'You were not previously authorized with this provider, ' \
              "but it has verified email (#{user.email}) that belongs to #{user.username}." \
              'For security purposes, you must verify this email to regain your role. ' \
              'Confirmation email has been sent to this email. ' \
              'Please follow the link in the email to verify your account. ' \
              'Until then you are authorized but unconfirmed'
          elsif new_email_passed
            "#{provider} didn't provide a mail so you provided your own. " \
              'Please confirm it. Confirmation email has been sent to this email.'
          end

    answer = "You have successfully #{action} in with #{provider}."
    msg.present? ? "#{answer} #{msg}" : answer
  end
end
