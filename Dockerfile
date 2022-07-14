FROM ruby:3.1.2-alpine

ARG BUNDLER_VERSION

RUN apk add --update --no-cache \
      binutils-gold \
      build-base \
      gcompat \
      curl \
      file \
      imagemagick \
      g++ \
      gcc \
      git \
      less \
      libstdc++ \
      libffi-dev \
      libc-dev \
      linux-headers \
      libxml2-dev \
      libxslt-dev \
      libgcrypt-dev \
      make \
      netcat-openbsd \
      openssl \
      pkgconfig \
      postgresql-dev \
      python3 \
      tzdata

# Remove bundle config if exist
RUN rm -f .bundle/config

RUN gem install bundler:$BUNDLER_VERSION

WORKDIR /app

# Install gems
ARG BUNDLE_WITHOUT
ENV BUNDLE_WITHOUT ${BUNDLE_WITHOUT}
RUN bundle config set without ${BUNDLE_WITHOUT}

COPY . /app/

RUN bundle config build.nokogiri --use-system-libraries
RUN bundle install -j4 --retry 3 \
 # Remove unneeded files (cached *.gem, *.o, *.c)
 && rm -rf /usr/local/bundle/cache/*.gem \
 && find /usr/local/bundle/gems/ -name "*.c" -delete \
 && find /usr/local/bundle/gems/ -name "*.o" -delete

# Remove folders not needed in resulting image
ARG FOLDERS_TO_REMOVE
RUN rm -rf $FOLDERS_TO_REMOVE

WORKDIR /app
