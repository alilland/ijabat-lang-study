require 'active_record'
require 'rake'
require 'fileutils'
require 'dotenv'
require 'httparty'
require "openai"

Dotenv.load('./.env.development')
Dir.glob('./lib/**/*.rb').sort.each { |file| load file }

require_relative 'models'

namespace :db do
  desc 'implode the database'
  task :full_reset do
    db_path = 'db/development.sqlite3'

    if File.exist?(db_path)
      FileUtils.rm(db_path)
      puts "Deleted #{db_path}"
    else
      puts "Database file does not exist, skipping deletion."
    end

    Rake::Task['db:setup'].invoke
  end

  desc "Set up the database and run migrations"
  task :setup do
    ActiveRecord::Base.establish_connection(
      adapter: 'sqlite3',
      database: 'db/development.sqlite3'
    )

    puts "Database setup complete! Run `bundle exec rake db:migrate` to apply migrations."
  end

  desc "Migrate the database"
  task :migrate do
    ActiveRecord::Base.establish_connection(
      adapter: 'sqlite3',
      database: 'db/development.sqlite3'
    )

    # Ensure the migrations directory exists
    migrations_path = File.expand_path('db/migrate')
    FileUtils.mkdir_p(migrations_path)

    # Run migrations
    ActiveRecord::MigrationContext.new(migrations_path).migrate
  end
end

Dir.glob('./tasks/**/*.rake').sort.each { |file| load file }
