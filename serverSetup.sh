#!/bin/bash
SECRETS="config/secrets.yml"
SECRET=`rake secret`
rm $SECRETS
echo -e "production:" >> $SECRETS
echo -e "\tsecret_key_base:" $SECRET >> $SECRETS

