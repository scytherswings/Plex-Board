#!/usr/bin/env bash
set -e

case "$(uname -s)" in

   Darwin)
     OS="Mac OSX"
     ;;

   Linux)
     OS="Linux"
     ;;

   CYGWIN*|MINGW32*|MSYS*)
     OS="Windows"
     ;;

   *)
     OS="Unknown"
     ;;
esac

printf "\nThe current operating system was detected as: ${OS}."

cd "$(dirname "$0")"
if [[ "$OS" != "Windows" ]]; then
  printf "\nStopping server if it's running.\n"
  source stopServer.sh
fi

printf "\nDestroying tmp folder to clear caches and leftover pidfiles.\n"
rm -rf tmp

printf "\nDestroying public/images to clear leftover images.\n"
rm -rf public/images

HOME_RVM=$HOME/.rvm/scripts/rvm
ROOT_RVM="/usr/local/rvm/scripts/rvm"
# Load RVM into a shell session *as a function*
if [[ -s ${HOME_RVM} ]] ; then
  # First try to load from a user install
  source ${HOME_RVM} \
  && printf "\nRVM successfully loaded from $HOME_RVM\n" \
  && printf "\nInstalling ruby-2.3.4 if it isn't already installed. This could take a while...\n" \
  && rvm install ruby-2.3.4 \
  && rvm use gemset ruby-2.3.4@plexdashboard

elif [[ -s ${ROOT_RVM} ]] ; then
  # Then try to load from a root install
  source ${ROOT_RVM} \
  && printf "\nRVM successfully loaded from $ROOT_RVM\n" \
  && printf "\nInstalling ruby-2.3.4 if it isn't already installed. This could take a while...\n" \
  && rvm install ruby-2.3.4 \
  && rvm use gemset ruby-2.3.4@plexdashboard

else
  if [[ "$OS" == "Windows" ]]; then
    printf "\nUsing system Ruby because we're on Windows...\n"
   else
    printf "\nWARNING: A RVM installation was not found. Did you follow the instructions correctly? Attempting to use system Ruby...\n"
  fi
fi

RUBY_VERSION="$(ruby -v)"

if ! [[ ${RUBY_VERSION} =~ 2\.3\.[0-9]+ ]];  then
  printf "\nERROR: The required version of ruby was not installed. This application will not work with any ruby < 2.3.x"
  printf "\nFound: ${RUBY_VERSION}\n"
  exit 1
fi

#This straight-up doesn't work right.

#BUNDLER_INSTALLED="$(gem list bundler -i)"
#echo ${BUNDLER_INSTALLED}
#if [[ "${BUNDLER_INSTALLED}" = false ]]; then
#  printf "Bundler was not installed. Installing...\n"
  gem install bundler rake --no-ri --no-rdoc
#  printf "After installing bundler you will need to refresh your PATH variables. Close and reopen your shell, re-login, or reboot."
#  exit 1
#fi

printf "\nInstalling Gems. This could take a while depending on how powerful your CPU is...\n"
bundle install --without development test

EXAMPLE_WINDOWS_CONFIG_FILE="example.windows.server_config.yml"
EXAMPLE_CONFIG_FILE="example.server_config.yml"
SERVER_CONFIG_FILE="server_config.yml"
SECRETS="config/secrets.yml"
SECRET="$(rake secret)"
BOGUS="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"

printf "\nRemoving old secrets.yml file if it exists. Creating a fresh one with new secrets.\n"
if [ -f ${SECRETS} ] ; then
    rm ${SECRETS}
fi

echo -e "development:\n  secret_key_base:" ${BOGUS} "\n" >> ${SECRETS}
echo -e "test:\n  secret_key_base:" ${BOGUS} "\n" >> ${SECRETS}
echo -e "production:\n  secret_key_base:" ${SECRET} >> ${SECRETS}

if [ ! -f ${SERVER_CONFIG_FILE} ]; then
  if [[ "$OS" == "Windows" ]]; then
    printf "\nSince windows is being used we'll use 127.0.0.1:3000 as the default host."
    printf "\nYou'll need to configure server_config.yml in order to accept traffic from external hosts.\n"
    EXAMPLE_CONFIG_FILE=${EXAMPLE_WINDOWS_CONFIG_FILE}
  fi

  if cp ${EXAMPLE_CONFIG_FILE} ${SERVER_CONFIG_FILE} 2>&1; then
    printf "\nCreated server_config.yml since it didn't exist."
  fi
else
    printf "\nserver_config.yml exists, not creating."
fi

printf "\nCreating and setting up the database for production.\n"
bundle exec rake db:create RAILS_ENV=production
bundle exec rake db:migrate RAILS_ENV=production

printf "\nCompiling assets. This could take a while depending on CPU power...\n"
bundle exec rake assets:clobber assets:precompile RAILS_ENV=production

printf "\nCreating images directory.\n"
mkdir -p public/images

printf "\nFinished. Run ./startServer.sh to start the server!\n\n"
