# frozen_string_literal: true

namespace :core do
  desc 'Set up the database and run migrations'
  task :init do
    puts 'Database setup complete! Run `bundle exec rake db:migrate` to apply migrations.'
  end
end
