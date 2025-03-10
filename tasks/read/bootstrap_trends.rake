# frozen_string_literal: true

namespace :read do
  desc "Iterate over each file in the Google Trends folder"
  task :bootstrap_trends do
    folder_path = File.expand_path('../../data/google-trends/christianity/2020-03-05-2025-03-05', __dir__)

    lib = {}

    Dir.glob("#{folder_path}/*").each do |file|
      next unless File.file?(file) # Skip directories

      parts = file.split('/')
      lang = parts.last.gsub('.csv', '').downcase
      puts "Processing: #{lang}"

      terms = []
      skip = false
      CSV.foreach(file, headers: true) do |row|
        # Process each row (example: print the first column)
        hash = row.to_h  # Convert row to hash and print
        skip = true if hash['Category: Christianity'] == 'RISING'
        next if hash['Category: Christianity'].blank?
        next if skip
        next if hash['Category: Christianity'] == 'TOP'

        ##
        # p hash['Category: Christianity']
        terms.push hash['Category: Christianity']

        trend = TrendTerm.where(lang: lang, source_term: hash['Category: Christianity']).first
        trend = TrendTerm.new if trend.nil?

        trend.lang = lang
        trend.source_term = hash['Category: Christianity'] || ''
        trend.normalized_term = OpenAI.trend_term_normalize(trend.lang, trend.source_term)
        trend.save
        puts "#{lang}: #{trend.source_term}"
      end
    end
  end
end
