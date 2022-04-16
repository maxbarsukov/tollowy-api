module Schemas # rubocop:disable Style/ClassAndModuleChildren
  class Base
    class << self
      def data
        raise NotImplementedError
      end

      def ref
        { '$ref' => "#/components/#{title}" }
      end

      def title
        name.underscore
      end
    end
  end
end
