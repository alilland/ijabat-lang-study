# frozen_string_literal: true

namespace :studies do
  namespace :s005 do
    task :stage_data do
      file_path = File.expand_path('../../../data/stepping_stones.json', __dir__)

      # Read and parse JSON file
      raise StandardError, "File not found: #{file_path}" unless File.exist?(file_path)

      json_data = JSON.parse(File.read(file_path))
      puts "JSON Data Loaded Successfully"
      # puts json_data.inspect # Print the JSON data for debugging

      languages = Language.all
      category = Category.first

      json_data.each do |data|
        p data['topic']
        languages.to_a.each do |lang|
          record = Term.find_or_initialize_by(
            study_number: 5,
            category_id: category.id,
            term: data['topic'],
            language: lang.lang,
            search_term: ''
          )
          record.assign_attributes(
            study_number: 5,
            id: record.id || SecureRandom.uuid,
            term: data['topic'],
            language: lang.lang,
            search_term: ''
          )

          record.save!
          puts "Inserted Term: #{record.term}/#{record.language} (ID: #{record.id})"
        rescue StandardError => e
          p e.message
        end
      end
    end
  end
end
