# frozen_string_literal: true

namespace :db do
  desc 'Migrate the database'
  task :migrate do
    # Ensure the migrations directory exists
    migrations_path = File.expand_path('db/migrate')
    FileUtils.mkdir_p(migrations_path)

    # Run migrations
    ActiveRecord::MigrationContext.new(migrations_path).migrate
  end
end
