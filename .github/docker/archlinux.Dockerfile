FROM archlinux:latest

RUN pacman -Syu --noconfirm git base-devel cmake

# Create lib directory
WORKDIR /home/lib
COPY . .

RUN cmake -S . -Bbuild -DLEMON_MAINTAINER_MODE=ON -DLEMON_BUILD_TESTING=ON
RUN cmake --build build --target all
RUN cmake --build build --target install -v -- DESTDIR=install
