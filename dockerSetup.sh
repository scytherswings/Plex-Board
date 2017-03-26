#!/bin/bash

SECRETS="config/secrets.yml"
SECRET="$(rake secret)"
echo
echo "Removing old secrets.yml file if it exists"
rm $SECRETS
touch $SECRETS
echo -e "development:\n  secret_key_base:" $SECRET "\n" >> $SECRETS
echo -e "test:\n  secret_key_base:" $SECRET "\n" >> $SECRETS
echo -e "production:\n  secret_key_base:" $SECRET >> $SECRETS
echo
echo "Creating and setting up new database for production"
bundle exec rake db:create RAILS_ENV=production
bundle exec rake db:schema:load RAILS_ENV=production
bundle exec rake db:migrate RAILS_ENV=production
echo
echo "Compiling assets"
bundle exec rake assets:precompile RAILS_ENV=production
echo
echo "Creating images directory"
mkdir -p public/images
echo
echo "Finished."
