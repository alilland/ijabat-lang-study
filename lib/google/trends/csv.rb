
module GoogleWrapper
  class Trends
    def self.query(keyword = "Jesus Christ", start_date = '2020-03-05', end_date = '2025-03-05', locale = 'en-US')
      # Generate dynamic request payload
      request_payload = {
        geo: {},
        comparisonItem: [
          {
            time: "#{start_date} #{end_date}",
            complexKeywordsRestriction: {
              keyword: [{ type: 'BROAD', value: keyword }]
            }
          }
        ],
        resolution: 'COUNTRY',
        locale: locale,
        requestOptions: {
          property: '',
          backend: 'IZG',
          category: 0
        },
        userConfig: {
          userType: 'USER_TYPE_LEGIT_USER'
        }
      }

      # Encode the payload properly
      encoded_request = URI.encode_www_form_component(request_payload.to_json)

      # 🛑 Replace with a fresh token manually retrieved from Google Trends
      fresh_token = "APP6_UEAAAAAZ8n8FvTekMBEYbNtIUtY6bhuQ1QNgxc7"

      # Construct the full URL dynamically
      trends_url = "https://trends.google.com/trends/api/widgetdata/comparedgeo/csv?req=#{encoded_request}&token=#{fresh_token}&tz=480"

      # Set HTTP Headers (optional, but improves success rate)
      headers = {
        "User-Agent" => "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36",
        "Accept-Language" => "en-US,en;q=0.9"
      }

      # Fetch the CSV file from Google Trends
      uri = URI(trends_url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      request = Net::HTTP::Get.new(uri, headers)
      response = http.request(request)

      # Handle response errors
      if response.code.to_i != 200
        puts "Error: #{response.code} - #{response.message}"
        puts "Response Body: #{response.body}"
        return []
      end

      # Remove non-CSV metadata and parse data
      csv_start_index = response.body.index("\n")
      cleaned_csv = csv_start_index ? response.body[csv_start_index..] : response.body

      # Print first few lines for debugging
      puts "Cleaned CSV Response:"
      puts cleaned_csv.lines.first(5)

      cleaned_csv
    end
  end
end
