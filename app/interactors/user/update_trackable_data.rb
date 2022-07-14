class User::UpdateTrackableData
  include Interactor

  delegate :user, :request, to: :context

  def call
    context.fail!(error_data:) if user.new_record? || user.blank?

    update_datetime
    update_ip
    update_signed_in_count

    context.fail!(error_data:) unless user.save
  end

  private

  def update_datetime
    old_current = user.current_sign_in_at
    new_current = Time.now.utc
    user.last_sign_in_at     = old_current || new_current
    user.current_sign_in_at  = new_current
  end

  def update_ip
    old_current = user.current_sign_in_ip
    new_current = extract_ip_from(request)
    user.last_sign_in_ip     = old_current || new_current
    user.current_sign_in_ip  = new_current
  end

  def update_signed_in_count
    user.sign_in_count ||= 0
    user.sign_in_count += 1
  end

  def extract_ip_from(request)
    request.remote_ip
  end

  def error_data
    ErrorData.new(
      status: 422,
      code: :unprocessable_entity,
      title: 'Invalid user'
    )
  end
end
