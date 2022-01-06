FROM ruby:2.7.5-alpine3.15
LABEL maintainer="renat@aomega.co"

RUN apk update \
    && apk upgrade \
    && apk add --update --no-cache \
    build-base zlib-dev sqlite sqlite-dev sqlite-libs

ADD . /app
WORKDIR /app
RUN bundle install

RUN apk del --purge build-base sqlite-dev
RUN rm -rf /var/cache/apk/*

EXPOSE 8081

#CMD ["/bin/sh"]
CMD ["ruby bot.rb"]