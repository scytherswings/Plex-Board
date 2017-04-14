# Base our image on an official, minimal image of our preferred Ruby
FROM ruby:2.3.4-slim

ENV RAILS_ROOT /var/www/plexdashboard
ENV RAILS_ENV production
# Install essential Linux packages
RUN apt-get update -qq && apt-get install -y \
    bundler \
    nodejs \
    curl \
    libsqlite3-dev \
    git \
  && rm -rf /var/lib/apt/lists/*


# Create application home. App server will need the pids dir so just create everything in one shot
RUN mkdir -p $RAILS_ROOT/tmp/pids

# Set our working directory inside the image
WORKDIR $RAILS_ROOT

# Use the Gemfiles as Docker cache markers. Always bundle before copying app src.
# (the src likely changed and we don't want to invalidate Docker's cache too early)
# http://ilikestuffblog.com/2014/01/06/how-to-skip-bundle-install-when-deploying-a-rails-app-to-docker/
COPY Gemfile Gemfile

COPY Gemfile.lock Gemfile.lock

# Prevent bundler warnings; ensure that the bundler version executed is >= that which created Gemfile.lock
RUN gem install bundler

# Finish establishing our Ruby enviornment
RUN bundle install --binstubs --without development test

# Copy the Rails application into place
COPY . .

RUN /var/www/plexdashboard/serverSetup.sh >> /tmp/bullshit.txt

EXPOSE 3000

# Define the script we want run once the container boots
# Use the "exec" form of CMD so our script shuts down gracefully on SIGTERM (i.e. `docker stop`)
CMD mkdir -p tmp/pids \
    && mkdir -p tmp/sockets \
    && touch tmp/pids/puma.pid \
    && touch tmp/sockets/puma.socket \
    && exec bundle exec puma -e production -C config/docker-puma.rb config.ru