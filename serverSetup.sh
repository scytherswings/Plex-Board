#!/bin/bash

echo "Installing Gems. This can take a bit of time..."
bundle install --without development test
echo
echo "Updating Gems.."
bundle update
echo
SECRETS="config/secrets.yml"
SECRET="$(rake secret)"
BOGUS="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
echo
echo "Removing old secrets.yml file if it exists"
rm $SECRETS
echo -e "development:\n  secret_key_base:" $BOGUS "\n" >> $SECRETS
echo -e "test:\n  secret_key_base:" $BOGUS "\n" >> $SECRETS
echo -e "production:\n  secret_key_base:" $SECRET >> $SECRETS
echo -e "RAILS_ENV=production"
echo
echo "Removing old databases if they exist"
rm db/*.sqlite3
echo
echo "Creating and setting up new database for production"
rake db:create RAILS_ENV=production
rake db:schema:load RAILS_ENV=production
rake db:migrate RAILS_ENV=production
rake assets:precompile RAILS_ENV=production
echo
echo "Creating images directory"
mkdir public/images
echo
echo "Finished. Run ./runServer.sh to start the server! It runs on port 3000 by default."