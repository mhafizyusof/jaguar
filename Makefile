##
# Pearl Make
# Copyright(c) 2012 King Pearl LLC
# MIT Licensed
##
SHELL := /bin/bash

APP = jaguar
ENV = testing production
JADE = $(shell find node_modules/jade/bin -maxdepth 3 -name "jade.js" -type f)
OPTIONS = { "filename": " ", "title": "Pearl", "description": "", "keywords": "" }
SENCHA = sencha
SERVE = $(shell find node_modules -name "serve" -type f)
PAGES = index.jade
REPO = kingpearl/$(APP)

all: configure compile

build:
	mkdir -p build
	mkdir -p resources/images
	$(foreach env,$(ENV),$(SENCHA) app build -e $(env);)

clean:
	rm -fR archive
	rm -fR build
	rm -fR docs
	rm -fR node_modules
	rm -f *.html
	rm -f resources/css/default/*.css
	rm -fR resources/sass/default/.sass-cache

compile:
	$(foreach page,$(PAGES),$(foreach view,$(shell find view -name "$(page)" -type f),$(JADE) $(view) -O '$(OPTIONS)' -o ./))

configure:
	npm install

docs:
	jsduck -o ./docs ./app.js ./app

push:
	rm -fR .git
	git init
	git add .
	git commit -m "Initial release"
	git remote add origin gh:$(REPO).git
	git push origin master

serve:
	$(SERVE) -f ./favicon.ico ./build/Pearl/testing/

.PHONY: build