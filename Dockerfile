FROM node:12.18.4 as node
FROM ruby:2.5.1

RUN apt-get update -qq && \
  apt-get install -y build-essential \
  mysql-server\
  mysql-client\
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

COPY --from=node /usr/local/lib/node_modules /usr/local/lib/node_modules
RUN ln -s /usr/local/lib/node_modules/npm/bin/npm-cli.js /usr/local/bin/npm
COPY --from=node /usr/local/bin/node /usr/local/bin/node
RUN npm install -g yarn

WORKDIR /fitO2

COPY Gemfile /fitO2/Gemfile
COPY Gemfile.lock /fitO2/Gemfile.lock

RUN gem install bundler
RUN bundle install

RUN mkdir -p tmp/sockets