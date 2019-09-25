CURRENT_DIR = $$(pwd)

# Подготовка Makefile
# https://habr.com/ru/post/449910/#makefile_preparation

# Использовать bash с опцией pipefail
# pipefail - фейлит выполнение пайпа, если команда выполнилась с ошибкой
SHELL=/bin/bash -o pipefail
# SHELL = /bin/bash

UNAME := $(shell uname)
BUILD_DATE := $(shell date +%Y%m%d-%H%M)

VERSION_FILE=./VERSION

# Если переменная CI_JOB_ID не определена
ifeq ($(CI_JOB_ID),)
  # присваиваем значение local
  CI_JOB_ID := local
endif

ifeq ($(TAG),)
  TAG := latest
endif

ifeq ($(CI_PROJECT_DIR),)
  CI_PROJECT_DIR := $(PWD)
endif

ifeq ($(MODE),)
  MODE := prod
endif

ifeq ($(APP_NAME),)
  APP_NAME := reaction
endif

ifeq ($(AWS_ECR_NAME),)
  AWS_ECR_NAME := "none"
endif

ifeq ($(AWS_REPO_NAME),)
  AWS_REPO_NAME := "grengojbo"
endif

ifeq ($(CI_JWERF_IMAGES_REPOOB_ID),)
  # WERF_IMAGES_REPO := "${AWS_ECR_NAME}/${AWS_REPO_NAME}/${APP_NAME}"
  WERF_IMAGES_REPO := "${AWS_REPO_NAME}/${APP_NAME}"
endif

ifeq ($(K8S_NAMESPACE),)
  K8S_NAMESPACE := "salesforcedocs"
endif

ifeq ($(DEPLOY_MODE),)
  DEPLOY_MODE := "none"
endif

ifeq ($(CLUSTER_NAME),)
  CLUSTER_NAME := "my-claster"
endif

ifeq ($(AWS_PROFILE),)
  AWS_PROFILE := "default"
endif

ifeq ($(AWS_REGION),)
  AWS_REGION := "eu-central-1"
endif


# Reaction
METEOR_VERSION := "1.8.0.2"
REACTION_DOCKER_BUILD := true
APP_SOURCE_DIR := "/opt/reaction/src"
APP_BUNDLE_DIR := "/opt/reaction/dist"
# ENV PATH $PATH:/home/node/.meteor
export METEOR_VERSION
export REACTION_DOCKER_BUILD
export APP_SOURCE_DIR
export APP_BUNDLE_DIR

export BUILD_DATE
export K8S_NAMESPACE
export CI_JOB_ID
export TAG
export CI_PROJECT_DIR
export MODE
export APP_NAME
export WERF_IMAGES_REPO
export DEPLOY_MODE
export CLUSTER_NAME
export AWS_PROFILE
export AWS_REGION
export COMPOSE_HTTP_TIMEOUT=120

# .PHONY: up

help: checker
	@echo " "
	@echo "make init    - установка зависемостей"
	@echo "make build   - сборка проекта"
	@echo "make release - сборка проекта и публикация изображения ${WERF_IMAGES_REPO}"
	@echo "make clean   - очищаем после сборки проекта"
	@echo "make start   - запуск локального контейнера в режиме daemon"
	@echo "make up      - запуск локального контейнера"
	@echo "make down    - остановка контейнера с удалением volumes"
	@echo "make connect - подключаемся к контейнеру"
	@echo "----------------------------------------------------------------------------"
	@echo "date: ${BUILD_DATE} version: ${VERSION}"
	@echo " "

checker:
ifeq ($(shell test -e $(VERSION_FILE) && echo -n yes),yes)
	@$(eval VERSION=$(shell cat $(VERSION_FILE)))
else
	@echo File $(VERSION_FILE) does not exist
	@exit 0;
endif

update:
	@sudo systemctl stop docker-compose@elasticsearch.service
	@git pull
	@cp ./env ./.env
	@sudo ./pre.sh
	@sudo systemctl start docker-compose@elasticsearch.service

build:
	@werf build --stages-storage :local --introspect-before-error

release:
	@werf build-and-publish --stages-storage :local --images-repo=${WERF_IMAGES_REPO} --tag-custom=${TAG}

clean:
	@echo "Start clean"
	@#werf images cleanup --images-repo=${WERF_IMAGES_REPO} --without-kube
	@werf stages cleanup --stages-storage :local --images-repo=${WERF_IMAGES_REPO}
	@#werf cleanup --stages-storage :local --images-repo=${WERF_IMAGES_REPO} --without-kube=true

pull:
	@echo "Download image: ${WERF_IMAGES_REPO}/${APP_NAME}:${TAG}"
	@mkdir -p /opt/data
	@docker-compose pull -q

start: pull
	@docker-compose up --build -v

up: pull
	@docker-compose up --build

down:
	@docker-compose down -v

connect:
	@docker-compose exec app /bin/bash

init:
	@echo "Установку зависемостей"
	@curl -L https://raw.githubusercontent.com/flant/multiwerf/master/get.sh | bash

# vim:ft=make:noet:ci:pi:sts=0:sw=2:ts=2:tw=78:fenc=utf-8:et
