namespace :data do
  namespace :ancestry do
    desc 'Rebuild ancestry path and depth information'
    task rebuild: :environment do
      puts <<~DESC
        This is going to take a while. For details...
        tail -f log/development.log
      DESC
      puts 'Rebuilding depth_cache...'
      Comment.rebuild_depth_cache!
      puts 'Checking ancestry integrity...'
      Comment.check_ancestry_integrity!
      puts 'Done.'
    end
  end
end
