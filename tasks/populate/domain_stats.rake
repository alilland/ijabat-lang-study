# frozen_string_literal: true

namespace :populate do
  task :domain_stats do
    ## flush domain stats
    DomainRank.destroy_all

    i = 0
    total_count = Term.count
    Term.all.to_a.each do |term|
      i += 1
      domains = JSON.parse(term.links) rescue []

      domains.each do |domain|
        curated_link = extract_root_domain(domain)
        record = DomainRank.where(domain: curated_link).first
        record = DomainRank.new if record.nil?
        record.domain = curated_link
        record.count = (record.count || 0) + 1
        record.save
      end

      puts "[#{i}/#{total_count}] #{term.language}:#{term.term}"
    end
  end
end
