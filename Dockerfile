# Base our image on an official, minimal image of our preferred Ruby
FROM ruby:2.4.1-slim

ENV RAILS_ROOT /app
ENV RAILS_ENV production
ENV DOCKER true
ENV LOG_TO_STDOUT true

# Install essential Linux packages
RUN apt-get update -qq \
    && apt-get install -y \
      bundler \
      nodejs \
      libsqlite3-dev \
    && rm -rf /var/lib/apt/lists/*

# Set our working directory inside the image
RUN mkdir $RAILS_ROOT
WORKDIR $RAILS_ROOT

# Use the Gemfiles as Docker cache markers. Always bundle before copying app src.
# (the src likely changed and we don't want to invalidate Docker's cache too early)
# http://ilikestuffblog.com/2014/01/06/how-to-skip-bundle-install-when-deploying-a-rails-app-to-docker/
COPY Gemfile Gemfile

COPY Gemfile.lock Gemfile.lock

# Prevent bundler warnings; ensure that the bundler version executed is >= that which created Gemfile.lock
RUN gem install bundler rake \
    && bundle install --jobs=5 --without development test \
    && bundle clean --force

# Copy the Rails application into place
COPY . .

RUN $RAILS_ROOT/serverSetup.sh

EXPOSE 3000

# Define the script we want run once the container boots
# Use the "exec" form of CMD so our script shuts down gracefully on SIGTERM (i.e. `docker stop`)
CMD exec bundle exec puma -e production -C $RAILS_ROOT/config/puma.rb $RAILS_ROOT/config.ru

VOLUME $RAILS_ROOT/db/


# Notes to remind me how to build this thing when I forget
# docker build -t plex-board .
