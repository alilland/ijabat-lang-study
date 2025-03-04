# frozen_string_literal: true

namespace :google do
  ##
  task :query do
    languages = Language.all.to_a
    languages.each do |lang|
      terms = Term.where(language: lang.lang)
      terms.each do |term|
        next if term.total_results > 0

        response = HTTParty.get('https://www.googleapis.com/customsearch/v1', query: {
          q: term.search_term,
          cx: ENV['GOOGLE_CSE_ID'],
          key: ENV['GOOGLE_API_KEY'],
          hl: lang.hl,
          lr: lang.lr
        })

        if response.success?
          total_results = response.parsed_response.dig('searchInformation', 'totalResults').to_i
          total_pages = (total_results.to_f / 10).ceil
          term.total_results = total_results

          puts "🔹 Total Search Results: #{total_results}"
          puts "🔹 Total Pages Available: #{total_pages}"

          links = response.parsed_response.dig('items')&.map { |item| item['link'] } || []
          unique_domains = links.map { |url| URI.parse(url).host rescue nil }.compact.uniq

          puts '🔹 Unique Domains:'
          puts unique_domains
          term.links = unique_domains.to_s
          term.save
        else
          puts "❌ Error: #{response.code} - #{response.message}"
        end

        sleep 5
      end
    end
  end
end
