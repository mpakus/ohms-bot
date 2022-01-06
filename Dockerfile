FROM ruby:2.7.5-alpine3.15

LABEL maintainer="renat@aomega.co"

ADD . /app
WORKDIR /app
RUN bundle install

EXPOSE 8081

CMD ["/bin/sh"]