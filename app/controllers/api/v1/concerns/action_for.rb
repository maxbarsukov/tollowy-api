module Api::V1::Concerns::ActionFor
  extend ActiveSupport::Concern

  private

  def action_for(name, ctx = {}, status = nil)
    module_name = controller_name.classify
    name = name.to_s.camelize

    result = "#{module_name}::#{name}".constantize.call(interactor_context(ctx))
    status ||= result.http_status
    status ||= :ok
    payload result, "#{module_name}::#{name}Payload".constantize, status:
  end
end
