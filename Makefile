reset:
	bundle exec rake db:full_reset
initialize:
	bundle exec rake db:setup
	bundle exec rake db:migrate
populate:
	bundle exec rake
