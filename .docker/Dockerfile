FROM node:current-alpine3.11 AS installer

WORKDIR /
RUN apk add git
RUN git clone --branch master --depth=1 https://github.com/asteroid-music/asteroid-flask && \ 
	git clone --branch master --depth=1 https://github.com/asteroid-music/asteroid-js

WORKDIR /asteroid-js
RUN npm i . && npm run build


FROM python:3.8.5-slim-buster
WORKDIR /
COPY --from=installer /asteroid-flask /asteroid
COPY --from=installer /asteroid-js/dist /asteroid/web
WORKDIR /asteroid

RUN pip install -r requirements.txt

RUN apt-get -qqy update \
    && apt-get install -y --no-install-recommends ca-certificates gnupg2 \
    && rm -rf /var/lib/apt/lists/*

RUN apt-key adv --keyserver keys.gnupg.net --recv-keys "539A3A8C6692E6E3F69B3FE81D85E93F801BB43F" \
    && echo "deb https://download.rethinkdb.com/repository/debian-buster buster main" > /etc/apt/sources.list.d/rethinkdb.list

ENV RETHINKDB_PACKAGE_VERSION 2.4.1~0buster

RUN apt-get -qqy update \
	&& apt-get install -y rethinkdb=$RETHINKDB_PACKAGE_VERSION \
	&& rm -rf /var/lib/apt/lists/*

VOLUME ["/data"]

RUN apt-get update && apt-get install -y supervisor
RUN mkdir -p /var/log/supervisor
COPY scripts/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

CMD ["/usr/bin/supervisord"]

EXPOSE 80 8080
