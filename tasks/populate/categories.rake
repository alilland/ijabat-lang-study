# frozen_string_literal: true

namespace :populate do
  task :categories do
    file_path = File.expand_path('../../data/categories.yaml', __dir__)

    unless File.exist?(file_path)
      puts "YAML file not found: #{file_path}"
      exit 1
    end

    categories = YAML.load_file(file_path)

    categories['categories'].each do |data|
      record = Category.find_or_initialize_by(category: data['name'])
      record.assign_attributes(
        id: record.id || SecureRandom.uuid,
        category: data['name']
      )

      record.save!
      puts "Inserted Category: #{record.category} (ID: #{record.id})"
    end
  end
end
