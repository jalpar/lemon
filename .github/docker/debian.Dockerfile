FROM debian:latest AS base

RUN apt-get update -qq \
&& apt-get install -yq \
 git wget build-essential cmake mercurial\
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Create lib directory
WORKDIR /home/lib
COPY . .
RUN cmake -S . -Bbuild -DLEMON_MAINTAINER_MODE=ON -DLEMON_BUILD_TESTING=ON
RUN cmake --build build --target all
RUN cmake --build build --target install -v -- DESTDIR=install
