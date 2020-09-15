FROM ruby:alpine

RUN apk update \
    && apk add --virtual build-dependencies build-base ttf-liberation \
    && gem install prawn humanize date ttfunk

WORKDIR /rents
COPY ./rent.rb .

CMD ["ruby", "rent.rb"]
