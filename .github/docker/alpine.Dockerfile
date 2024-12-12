FROM alpine:edge

RUN apk add --no-cache git build-base cmake mercurial

# Create lib directory
WORKDIR /home/lib
COPY . .

RUN cmake -S . -Bbuild -DLEMON_MAINTAINER_MODE=ON -DLEMON_BUILD_TESTING=ON
RUN cmake --build build --target all
RUN cmake --build build --target install -v -- DESTDIR=install
