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
RUN apt-get update && apt-get install -y ffmpeg

CMD ["python", "-m", "flask", "run", "-h", "0.0.0.0"]

EXPOSE 80 8080
