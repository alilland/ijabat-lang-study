# frozen_string_literal: true

namespace :studies do
  namespace :s005 do
    task :domain_stats do
      ## flush domain stats
      DomainRank.where(study_number: 5).destroy_all

      i = 0
      total_count = Term.where(study_number: 5).count
      Term.where(study_number: 5).to_a.each do |term|
        i += 1
        domains = JSON.parse(term.links) rescue []

        domains.each do |domain|
          curated_link = extract_root_domain(domain)
          record = DomainRank.where(domain: curated_link, study_number: 5).first
          record = DomainRank.new(study_number: 5) if record.nil?
          record.domain = curated_link
          record.count = (record.count || 0) + 1
          record.save
        end

        puts "[#{i}/#{total_count}] #{term.language}:#{term.term}"
      end
    end
  end
end
