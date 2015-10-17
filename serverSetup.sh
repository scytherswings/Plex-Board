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
`rake db:create db:schema:load`
`rake db:migrate`
`rake assets:precompile`

