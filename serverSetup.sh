#!/bin/bash
rm config/secrets.yml
echo "production: secret_key_base: " >> config/secrets.yml
rake secret >> config/secrets.yml
