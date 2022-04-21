module Schemas # rubocop:disable Style/ClassAndModuleChildren
  class Base
    class << self
      def data
        raise NotImplementedError
      end

      def ref
        { '$ref' => "#/components/schemas/#{title}" }
      end

      def title
        name.delete_prefix('Schemas::').underscore.gsub('/', '_')
      end
    end
  end
end
