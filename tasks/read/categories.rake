namespace :read do
  desc 'Populate categories and terms from YAML'
  task :categories do
    ActiveRecord::Base.establish_connection(
      adapter: 'sqlite3',
      database: 'db/development.sqlite3'
    )

    file_path = File.expand_path('../../data/categories.yaml', __dir__)

    unless File.exist?(file_path)
      puts "YAML file not found: #{file_path}"
      exit 1
    end

    categories = YAML.load_file(file_path)

    categories['categories'].each do |category_data|
      category = Category.find_or_create_by!(id: SecureRandom.uuid, category: category_data['name'])
      puts "Inserted Category: #{category.category} (ID: #{category.id})"

      category_data['terms'].each do |term_data|
        term_data['translations'].each do |language, translation|
          term = Term.create!(
            category_id: category.id,
            term: term_data['term'],
            language: language,
            search_term: translation
          )
          puts "  Inserted Term: #{term.term} (#{term.language}) → #{term.search_term}"
        end
      end
    end
  end
end
