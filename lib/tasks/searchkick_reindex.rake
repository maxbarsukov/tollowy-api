namespace :searchkick do
  namespace :reindex do
    namespace :custom do
      desc 'reindex all models with custom includes'
      task all: :environment do
        if Rails.respond_to?(:autoloaders) && Rails.autoloaders.zeitwerk_enabled?
          # fix for https://github.com/rails/rails/issues/37006
          Zeitwerk::Loader.eager_load_all
        else
          Rails.application.eager_load!
        end

        Searchkick.models.each do |model|
          puts "Reindexing #{model.name}..."
          case model.name
          when 'Post'
            puts '- (reindexing with tags)'
            Post.includes(:tags).reindex
          else
            model.reindex
          end
        end

        puts 'Reindex complete'
      end
    end
  end
end
