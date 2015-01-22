FROM ruby:2.2.0
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app
COPY keys.rb /usr/src/app/
ENTRYPOINT ["ruby", "keys.rb"]
