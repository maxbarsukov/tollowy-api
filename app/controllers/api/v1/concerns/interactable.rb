module Api::V1::Concerns::Interactable
  extend ActiveSupport::Concern

  private

  def interactor_context(hash = {})
    {
      controller: self,
      current_user: current_user
    }.merge(hash)
  end
end
