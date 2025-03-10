# frozen_string_literal: true

namespace :populate do
  task :translate_terms do
    ##
    # ! iterate over each term in the database, re-translate the search_term value using chatGPT API
    # ! reset the total_result value
    # ! reset the links value
    Term.update_all(total_results: 0, links: '[]', search_term: '')

    terms = Term.all.to_a
    i = 0
    total_count = terms.length
    sleep_time = 1 # Start with 1 second

    terms.each do |term|
      i += 1
      begin
        res = OpenAI.translate(term.term, term.language)
        term.search_term = res
        term.save
        puts "[#{i}/#{total_count}] Translated #{term.term} into #{term.language}, result: #{res}"

        sleep sleep_time # Adaptive sleep
      rescue => e
        puts "Error encountered: #{e.message}"
        if e.message.include?("429") # Rate limit hit
          sleep_time *= 2 # Double the sleep time
          puts "Rate limit reached. Increasing sleep time to #{sleep_time}s."
          sleep sleep_time
        else
          sleep 5 # Generic error: wait 5 seconds
        end
      end
    end
  end
end
