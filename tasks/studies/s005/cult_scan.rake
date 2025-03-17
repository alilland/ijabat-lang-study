# frozen_string_literal: true

namespace :studies do
  namespace :s005 do
    task :cult_scan do
      total_count = Term.where(study_number: 5).count
      i = 0

      terms = Term.where(study_number: 5)
      terms.each do |term|
        i += 1

        links = JSON.parse(term.links) rescue []
        is_infested = false

        links.each do |link|
          next if is_infested

          root_domain = extract_root_domain(link)
          is_infested = KnownCults.domains.include?(root_domain)
          ##
        end

        if is_infested
          term.has_cults = is_infested
          term.save
        end

        puts "[#{i}/#{total_count}] is_infested: #{is_infested} - #{term.language}:#{term.term}"
      end
    end
  end
end
