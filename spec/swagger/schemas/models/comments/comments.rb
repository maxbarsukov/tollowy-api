class Schemas::Comments < Schemas::Base
  def self.data
    {
      title: 'Comments',
      description: 'Comments',
      type: :array,
      items: Schemas::Comment.ref
    }
  end
end
