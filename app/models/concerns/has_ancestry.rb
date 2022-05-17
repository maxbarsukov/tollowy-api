module HasAncestry
  extend ActiveSupport::Concern

  included do
    def parent_or_root_post
      parent || commentable
    end

    def parent_user
      parent_or_root_post.user
    end

    def root_exists?
      ancestry && self.class.exists?(id: ancestry)
    end

    def parent_exists?
      parent_id && self.class.exists?(id: parent_id)
    end

    def self.with_parents
      table_name = name.constantize.table_name
      joins("INNER JOIN #{table_name} AS parents on
             SUBSTR(#{table_name}.ancestry, STRPOS(#{table_name}.ancestry, '/') + 1)::bigint = parents.id")
    end
  end
end
