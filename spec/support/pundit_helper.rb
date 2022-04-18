module PunditHelper
  extend ::RSpec::Matchers::DSL

  matcher :permit_with_multiple do |user, *args|
    match_proc = lambda do |policy|
      @violating_permissions = permissions.find_all do |permission|
        !policy.new(user, *args).public_send(permission)
      end
      @violating_permissions.empty?
    end

    match_when_negated_proc = lambda do |policy|
      @violating_permissions = permissions.find_all do |permission|
        policy.new(user, *args).public_send(permission)
      end
      @violating_permissions.empty?
    end

    failure_message_proc = lambda do |policy|
      was_were = @violating_permissions.count > 1 ? 'were' : 'was'
      "Expected #{policy} to grant #{permissions.to_sentence} on " \
        "#{args} but #{@violating_permissions.to_sentence} #{was_were} not granted"
    end

    failure_message_when_negated_proc = lambda do |policy|
      was_were = @violating_permissions.count > 1 ? 'were' : 'was'
      "Expected #{policy} not to grant #{permissions.to_sentence} on " \
        "#{args} but #{@violating_permissions.to_sentence} #{was_were} granted"
    end

    if respond_to?(:match_when_negated)
      match(&match_proc)
      match_when_negated(&match_when_negated_proc)
      failure_message(&failure_message_proc)
      failure_message_when_negated(&failure_message_when_negated_proc)
    else
      match_for_should(&match_proc)
      match_for_should_not(&match_when_negated_proc)
      failure_message_for_should(&failure_message_proc)
      failure_message_for_should_not(&failure_message_when_negated_proc)
    end

    def permissions
      current_example = ::RSpec.respond_to?(:current_example) ? ::RSpec.current_example : example
      current_example.metadata[:permissions]
    end
  end
end
