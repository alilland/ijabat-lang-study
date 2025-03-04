# frozen_string_literal: true

namespace :core do
  desc 'implode the database'
  task :reset do
    db_pattern = 'db/development.sqlite3*'

    Dir.glob(db_pattern).each do |db_file|
      FileUtils.rm(db_file)
      puts "Deleted #{db_file}"
    end

    if Dir.glob(db_pattern).empty?
      puts 'No matching database files found, skipping deletion.'
    end
  end
end
