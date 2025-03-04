reset:
	bundle exec rake core:reset
migrate:
	bundle exec rake db:migrate
initialize:
	bundle exec rake core:init
	bundle exec rake db:migrate
populate:
	bundle exec rake populate:languages
	bundle exec rake populate:categories
	bundle exec rake populate:terms
fill_webdata:
	bundle exec rake google:query
