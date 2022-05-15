class ApplicationFixture
  class << self
    # rubocop:disable Metrics/AbcSize
    def seed(options = {})
      options[:force] ||= ENV.fetch('force', 'false')
      options[:export] ||= ENV.fetch('export', 'true')

      if klass.exists? && options[:force] != 'true'
        puts "# #{klass_name.pluralize} already exists"
        return
      end

      yield if block_given?
      DbCsvLoader.export_table(klass_name.downcase.pluralize) if options[:export] == 'true'
    end
    # rubocop:enable Metrics/AbcSize

    def import(array)
      klass.import! array
    end

    def klass_name
      to_s.split(/(?=[A-Z])/).first
    end

    def klass
      klass_name.classify.constantize
    end
  end
end
