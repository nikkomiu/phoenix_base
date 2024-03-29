FROM debian:jessie-slim

# WARNING: This expects there to be a release in the _build/prod/rel/ directory

MAINTAINER Nikko Miu <nikkoamiu@gmail.com>

# Install Dependencies
RUN apt-get update && apt-get install -y libssl1.0.0

# Build Arguments
ARG APP_VER=0.0.1
ARG MIX_ENV=prod

# Copy release
COPY _build/prod/rel/phoenix_base/ /usr/phoenix_base/
WORKDIR /usr/phoenix_base
RUN chmod +x bin/*

# Runtime ENV
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV SECRET_KEY_BASE=xeqWUJ03Yx7JQ+if21rLBKIZ6cZKMyp3hcJYuC3U0NDQKe1APerQ3F5rD/E3s+e1
ENV DATABASE_URL=ecto://postgres:postgres@192.168.99.100/phoenix_base_prod
ENV PORT=8080

# Expose app port
EXPOSE $PORT

# Start app
ENTRYPOINT ["./bin/phoenix_base", "foreground"]
