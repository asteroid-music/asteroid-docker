FROM python:3.8-alpine

RUN apk add git

WORKDIR /

RUN git clone \
	--branch master \
	--depth=1 \
	https://github.com/asteroid-music/asteroid-flask && \
	cd asteroid-flask && \
	pip install -r requirements.txt

WORKDIR /asteroid-flask

ENTRYPOINT ["flask", "run", "-h", "0.0.0.0", "-p", "8080"]
