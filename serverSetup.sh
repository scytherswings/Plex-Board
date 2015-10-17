#!/bin/bash
SECRETS="config/secrets_test.yml"
SECRET=`rake secret`
rm $SECRETS
echo -e "production:\n\tsecret_key_base:" $SECRET >> $SECRETS

