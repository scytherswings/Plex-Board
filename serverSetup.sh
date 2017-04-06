#!/bin/bash

SERVER_CONFIG_FILE="server_config.yml"
SECRETS="config/secrets.yml"
SECRET="$(rake secret)"
BOGUS="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"

echo "Installing Gems. This can take a bit of time..."
bundle install --without development test
echo
echo "Destroying tmp folder to clear caches etc."
rm -rf tmp
echo
echo "Removing old secrets.yml file if it exists. Creating a fresh one with new secrets."
rm $SECRETS
echo -e "development:\n  secret_key_base:" $BOGUS "\n" >> $SECRETS
echo -e "test:\n  secret_key_base:" $BOGUS "\n" >> $SECRETS
echo -e "production:\n  secret_key_base:" $SECRET >> $SECRETS
echo -e "RAILS_ENV=production"
echo

if [ ! -f ${SERVER_CONFIG_FILE} ]; then
 if cp example.server_config.yml ${SERVER_CONFIG_FILE} 2>&1; then
    echo "Created server_config.yml since it didn't exist"
 fi
else
    echo "server_config.yml exists, not creating."
fi

echo "Creating and setting up the database for production"
bundle exec rake db:create RAILS_ENV=production
bundle exec rake db:migrate RAILS_ENV=production
echo
echo "Compiling assets"
bundle exec rake assets:clobber assets:precompile RAILS_ENV=production
echo
echo "Creating images directory"
mkdir -p public/images
echo
echo "Finished. Run ./runServer.sh to start the server! It runs on port 3000 by default."
