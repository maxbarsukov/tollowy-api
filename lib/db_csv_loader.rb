require 'csv'

module DbCsvLoader
  module_function

  def export_table(table)
    file = Rails.root.join('db', 'fixtures', "#{table}.csv")
    klass = table.singularize.classify.constantize

    # rubocop:disable Style/Semicolon, Lint/Void
    table = klass.all; 0
    # rubocop:enable Style/Semicolon, Lint/Void

    CSV.open(file, 'w') do |writer|
      writer << table.first.attributes.map { |a, _v| a }
      table.each do |s|
        writer << s.attributes.map { |_a, v| v }
      end
    end
  end

  def import_table(filename)
    table = []
    CSV.foreach(filename, headers: true) do |row|
      table << row.to_h
    end

    klass_name = File.basename(filename, '.csv').singularize.classify.constantize
    klass_name.import(table)
  end
end
