if ENV['load']
  Dir[Rails.root.join('db/fixtures/*.csv')].each do |filename|
    puts "loading: #{File.basename(filename)}"
    DbCsvLoader.import_table(filename)
  end
else
  Dir[Rails.root.join('db/fixtures/*.rb')].each do |filename|
    puts "seeding: #{File.basename(filename)}"
    load(filename)
  end
end
