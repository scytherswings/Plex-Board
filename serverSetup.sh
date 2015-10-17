#!/bin/bash
SECRETS="config/secrets.yml"
SECRET=`rake secret`
rm $SECRETS
echo -e "production:\n  secret_key_base:" $SECRET >> $SECRETS
rake db:migrate

