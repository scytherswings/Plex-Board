#!/bin/bash
echo "production: secret_key_base: " >> config/secrets.yml
rake secret >> config/secrets.yml
rails server
