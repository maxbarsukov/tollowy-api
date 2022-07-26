class Schemas::Versions < Schemas::Base
  def self.data
    {
      title: 'Versions',
      description: 'Versions',
      type: :array,
      items: Schemas::Version.ref
    }
  end
end
