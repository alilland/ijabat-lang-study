# frozen_string_literal: true

namespace :read do
  task :gpt_score_sample do
    search_term = 'इसाई धर्मका आधारहरू'
    domains = ["m.facebook.com", "deshsanchar.com", "www.hamropatro.com", "nepjol.info", "ghatanarabichar.com", "shilapatra.com", "nepalnamcha.com", "huggingface.co", "ne.wikipedia.org", "khabarhub.com"]
    total_results = 75

    result = GPT.analyze_search_term(search_term, domains, total_results)
    puts result
  end
end
