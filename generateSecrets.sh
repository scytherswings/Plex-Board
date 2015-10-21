#!/bin/bash
SECRETS="config/secrets.yml"
SECRET="$(rake secret)"
BOGUS="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
echo
echo "Removing old secrets.yml file if it exists"
rm $SECRETS
echo -e "development:\n  secret_key_base:" $BOGUS "\n" >> $SECRETS
echo -e "test:\n  secret_key_base:" $BOGUS "\n" >> $SECRETS
echo -e "production:\n  secret_key_base:" $SECRET >> $SECRETS
echo "config/secrets.yml was generated probably."
