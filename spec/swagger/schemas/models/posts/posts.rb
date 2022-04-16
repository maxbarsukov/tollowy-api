class Schemas::Posts < Schemas::Base
  def self.data
    {
      title: 'Posts',
      description: 'Posts',
      type: :array,
      items: Schemas::Post.ref
    }
  end
end
