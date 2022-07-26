class Schemas::Parameter::Versions::Create < Schemas::Base
  def self.data
    {
      **SwaggerGenerator.generate_data(
        'version',
        attr: { properties: Schemas::VersionAttributes.data[:properties] }
      ),
      example: {
        data: {
          type: 'version',
          attributes: {
            v: '12.1.2',
            link: 'https://raw.followy.ru/v/12.1.2',
            size: 31_457_280,
            for_role: 'moderator',
            whats_new: 'Fixed old bugs, added new ones'
          }
        }
      }
    }
  end
end
