FROM ruby:2.7.2
RUN apt-get update -qq && apt-get install -y postgresql-client
WORKDIR /app

# install nodejs(LTS)
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - && apt-get install -y nodejs

# install yarn
RUN npm install --global yarn

# gem
COPY Gemfile* /app/
RUN gem update --system 3.3.5
RUN gem install --force bundler -v '2.3.5'
RUN bundle install

# If need run some script
# COPY entrypoint.sh /usr/bin/
# RUN chmod +x /usr/bin/entrypoint.sh
# ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Configure the main process to run when running the image
CMD ["rails", "server", "-b", "0.0.0.0"]