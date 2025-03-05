# frozen_string_literal: true

require 'httparty'

namespace :populate do
  task :google_terms do
    total_terms = Term.count
    i = 0
    failed_terms = {}

    languages = Language.all.to_a
    languages.each do |lang|
      terms = Term.where(language: lang.lang)
      terms.each do |term|
        i += 1
        next if term.total_results > 0
        next if failed_terms[term.id] && failed_terms[term.id] >= 3 # Skip terms that failed multiple times

        response = nil
        attempt = 0

        begin
          attempt += 1
          response = HTTParty.get('https://www.googleapis.com/customsearch/v1',
            query: {
              q: term.search_term,
              cx: ENV['GOOGLE_CSE_ID'],
              key: ENV['GOOGLE_API_KEY'],
              hl: lang.hl,
              lr: lang.lr
            },
            timeout: 10 # Set a timeout to avoid hanging requests
          )

          if response.success?
            total_results = response.parsed_response.dig('searchInformation', 'totalResults').to_i
            links = response.parsed_response.dig('items')&.map { |item| item['link'] } || []
            unique_domains = links.map { |url| URI.parse(url).host rescue nil }.compact.uniq

            term.update(total_results: total_results, links: unique_domains.to_s)

            puts "[#{i}/#{total_terms}] updated #{lang.lang}:#{term.term}, total hits: #{total_results}"
          elsif response.code == 429 # Too Many Requests
            raise "Rate Limited (429)"
          else
            puts "❌ Error: #{response.code} - #{response.message}"
          end
        rescue Net::OpenTimeout, Net::ReadTimeout, Errno::ECONNRESET, Errno::ETIMEDOUT, SocketError => e
          puts "⚠️ Timeout/Error: #{e.message} - Retrying in #{attempt * 2}s..."
          sleep attempt * 2
          retry if attempt <= 3
          failed_terms[term.id] = attempt # Track failed term
        rescue => e
          puts "❌ Fatal Error for term #{term.term}: #{e.message}"
        end

        sleep 1 # Reduce API pressure, adjust as needed
      end
    end
  end
end
