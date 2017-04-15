#!/bin/bash
mv example.server_config.yml server_config.yml
SECRETS="config/secrets.yml"
SECRET="$(bundle exec rake secret)"
BOGUS="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
# rm $SECRETS
echo -e "development:\n  secret_key_base: " ${BOGUS} "\n" >> ${SECRETS}
echo -e "test:\n  secret_key_base: " ${BOGUS} "\n" >> ${SECRETS}
echo -e "production:\n secret_key_base: " ${SECRET} >> ${SECRETS}
# rm db/*sqlite3
mkdir -p log/
touch log/test.log
bundle exec rake db:create
bundle exec rake db:migrate
mkdir -p public/images
mkdir -p test/test_images

