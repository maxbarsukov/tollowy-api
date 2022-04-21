class Schemas::Parameter::Auth::SignOut < Schemas::Base
  def self.data
    {
      type: :string, nullable: true,
      enum: %w[true false]
    }
  end
end
