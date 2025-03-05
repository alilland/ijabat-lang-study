# frozen_string_literal: true

namespace :read do
  task :audit_terms do
    languages = Language.all.to_a
    languages.each do |lang|
      ## Iterate over each language searching for terms
      terms = Term.where(language: lang.lang).to_a

      list = terms.map(&:search_term)
      unique_list = list.uniq

      puts "#{lang.lang} has duplicates" if unique_list.length < list.length

      next unless unique_list.length < list.length

      hash = {}
      terms.each do |t|
        hash[t.term] = t.search_term
      end
      p hash
      puts ''
    end
  end
end
