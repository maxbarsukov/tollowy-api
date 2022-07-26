class Schemas::Parameter::Versions::Update < Schemas::Base
  def self.data
    {
      **Schemas::Parameter::Versions::Create.data,
      example: {
        data: {
          type: 'version',
          attributes: {
            whats_new: 'Fixed old bugs, added new ones | updated!'
          }
        }
      }
    }
  end
end
