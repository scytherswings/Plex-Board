#!/bin/bash
SECRETS="config/secrets.yml"
SECRET="$(bundle exec rake secret)"
BOGUS="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
# rm $SECRETS
echo -e "development:\n  secret_key_base: " $BOGUS "\n" >> $SECRETS
echo -e "test:\n  secret_key_base: " $BOGUS "\n" >> $SECRETS
echo -e "production:\n secret_key_base: " $SECRET >> $SECRETS
# rm db/*sqlite3
rake db:create
rake db:migrate