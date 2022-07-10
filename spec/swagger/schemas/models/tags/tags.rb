class Schemas::Tags < Schemas::Base
  def self.data
    {
      title: 'Tags',
      description: 'Tags',
      type: :array,
      items: Schemas::Tag.ref
    }
  end
end
