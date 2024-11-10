# syntax=docker/dockerfile:1

FROM ghcr.io/linuxserver/baseimage-kasmvnc:ubuntunoble

# set version label
ARG BUILD_DATE
ARG VERSION
ARG YAAK_RELEASE
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="aptalca"

ENV \
  HOME="/config" \
  TITLE="Yaak"

RUN \
  echo "**** add icon ****" && \
  curl -o \
    /kclient/public/icon.png \
    https://raw.githubusercontent.com/linuxserver/docker-templates/master/linuxserver.io/img/yaak-icon.png && \
  echo "**** install yaak ****" && \
  apt-get update && \
  if [ -z ${YAAK_RELEASE+x} ]; then \
    YAAK_RELEASE=$(curl -sX GET "https://api.github.com/repos/octoputapp/yaak/releases/latest" \
      | jq -r .tag_name); \
  fi && \
  YAAK_VERSION=$(echo "${YAAK_RELEASE}" | sed 's|^v||') && \
  curl -o \
    /tmp/yaak.deb -L \
    "https://github.com/octoputapp/yaak/releases/download/v${YAAK_VERSION}/yaak_${YAAK_VERSION}_amd64.deb" && \
  apt-get install -y --no-install-recommends \
    /tmp/yaak.deb && \
  printf "Linuxserver.io version: ${VERSION}\nBuild-date: ${BUILD_DATE}" > /build_version && \
  echo "**** cleanup ****" && \
  apt-get clean && \
  rm -rf \
    /tmp/* \
    /var/lib/apt/lists/* \
    /var/tmp/*

# add local files
COPY root/ /
