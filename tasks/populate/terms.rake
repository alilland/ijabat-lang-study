# frozen_string_literal: true

namespace :populate do
  task :terms do
    file_path = File.expand_path('../../data/categories.yaml', __dir__)

    unless File.exist?(file_path)
      puts "YAML file not found: #{file_path}"
      exit 1
    end

    categories = YAML.load_file(file_path)

    languages = Language.all

    categories['categories'].each do |data|
      category = Category.find_by(category: data['name'])
      next unless category

      data['terms'].each do |t|
        languages.to_a.each do |lang|
          translation = GPT.translate(t['term'], lang.lang, lang.hl, lang.lr)

          record = Term.find_or_initialize_by(
            category_id: category.id,
            term: t['term'],
            language: lang.lang,
            search_term: translation
          )
          record.assign_attributes(
            id: record.id || SecureRandom.uuid,
            term: t['term'],
            language: lang.lang,
            search_term: translation
          )

          record.save!
          puts "Inserted Term: #{record.term}/#{record.language} (ID: #{record.id})"
        end
      end
    end
  end
end
