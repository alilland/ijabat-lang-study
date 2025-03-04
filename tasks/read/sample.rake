namespace :read do
  task :sample do
    query = "مسیحیت چیست؟"

    response = HTTParty.get("https://www.googleapis.com/customsearch/v1", query: {
      q: query,
      cx: ENV['GOOGLE_CSE_ID'],
      key: ENV['GOOGLE_API_KEY'],
      hl: 'fa',       # Interface language (Farsi Google)
      lr: 'lang_fa'   # Restrict results to Farsi pages
    })

    # puts response.parsed_response
    if response.success?
      total_results = response.parsed_response.dig("searchInformation", "totalResults").to_i
      total_pages = (total_results.to_f / 10).ceil

      puts "🔹 Total Search Results: #{total_results}"
      puts "🔹 Total Pages Available: #{total_pages}"

      links = response.parsed_response.dig("items")&.map { |item| item["link"] } || []
      unique_domains = links.map { |url| URI.parse(url).host rescue nil }.compact.uniq

      puts '🔹 Unique Domains:'
      puts unique_domains
    else
      puts "❌ Error: #{response.code} - #{response.message}"
    end
  end
end
