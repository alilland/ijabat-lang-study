# frozen_string_literal: true

namespace :populate do
  task :languages do
    file_path = File.expand_path('../../data/lang_map.yaml', __dir__)

    unless File.exist?(file_path)
      puts "YAML file not found: #{file_path}"
      exit 1
    end

    languages = YAML.load_file(file_path)

    languages['languages'].each do |data|
      lang = Language.find_or_initialize_by(lang: data['lang'])
      lang.assign_attributes(
        id: lang.id || SecureRandom.uuid,
        hl: data['hl'],
        lr: data['lr']
      )

      lang.save!
      puts "Inserted Language: #{lang.lang} (ID: #{lang.id})"
    end
  end
end
