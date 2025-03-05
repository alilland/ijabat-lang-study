# frozen_string_literal: true

namespace :populate do
  task :terms_score do
    ##
    # ! iterate over each term in the database, re-translate the search_term value using chatGPT API
    # ! reset the total_result value
    # ! reset the links value
    # Term.update_all(score: 0, difficulty: '')

    terms = Term.where(difficulty: '').to_a
    i = 0
    total_count = terms.length
    sleep_time = 1 # Start with 1 second

    terms.each do |term|
      i += 1
      begin
        links = JSON.parse(term.links) rescue []
        res = GPT.analyze_search_term(term.search_term, links, term.total_results)
        term.score = res['score']
        term.difficulty = res['difficulty']
        term.save
        puts "[#{i}/#{total_count}] score: #{term.score}, difficulty: #{term.difficulty}, lang: #{term.language}, term #{term.term}"

        sleep sleep_time # Adaptive sleep
      rescue StandardError => e
        puts "Error encountered: #{e.message}"
        if e.message.include?('429') # Rate limit hit
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
