namespace :db do
  namespace :seed do
    Dir[File.join(Rails.root, "db", "seeds", "*rb")].each do |filename|
      task_name = File.basename(filename, ".rb").intern
      seed_file_with_relative_path = Pathname.new(filename).relative_path_from(Rails.root)
      desc "Loads seed data from '#{seed_file_with_relative_path}'"
      task task_name => :environment do
        load(filename) if File.exist?(filename)
      end
    end
  end
end
