reset:
	bundle exec rake core:reset
migrate:
	bundle exec rake db:migrate
initialize:
	bundle exec rake core:init
	bundle exec rake db:migrate
	bundle exec rake populate:languages
	bundle exec rake populate:categories
	bundle exec rake populate:terms
translate_terms:
	bundle exec rake populate:translate_terms
fill_webdata:
	bundle exec rake populate:google_terms
enrich_data:
	bundle exec rake populate:terms_scan_for_cults
	bundle exec rake populate:terms_score
	bundle exec rake populate:domain_stats

