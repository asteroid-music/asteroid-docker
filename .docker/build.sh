#!/bin/bash

docker build \
	. \
	-t asteroid \
	--no-cache \
	--rm
