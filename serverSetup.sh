#!/bin/bash
SECRETS="config/secrets.yml"
SECRET=`rake secret`
BOGUS="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
`rm $SECRETS`
echo -e "development:\n  secret_key_base:" $BOGUS "\n" >> $SECRETS
echo -e "test:\n  secret_key_base:" $BOGUS "\n" >> $SECRETS
echo -e "production:\n  secret_key_base:" $SECRET >> $SECRETS
echo -e "RAILS_ENV=production"
`rm db/*.sqlite3`
`rake db:create RAILS_ENV=production`
`rake db:schema:load RAILS_ENV=production`
`rake db:migrate RAILS_ENV=production`
`rake assets:precompile RAILS_ENV=production`