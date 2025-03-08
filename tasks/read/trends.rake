# frozen_string_literal: true

namespace :read do
  task :trends do
    GoogleWrapper::Trends.query('Bible')
  end
end
