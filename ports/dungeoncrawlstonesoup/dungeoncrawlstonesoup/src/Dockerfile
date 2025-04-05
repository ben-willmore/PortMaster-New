FROM ubuntu:focal

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update

RUN apt install -y --no-install-recommends \
        build-essential \
        ca-certificates apt-utils nano wget git

# newer version of gcc
RUN apt install -y gcc-10 g++-10

RUN apt install -y \
  build-essential libncursesw5-dev bison flex liblua5.1-0-dev \
  libsqlite3-dev libz-dev pkg-config python3-yaml \
  binutils-gold python-is-python3

RUN apt install -y \
  libsdl2-image-dev libsdl2-mixer-dev libsdl2-dev \
  libfreetype6-dev libpng-dev fonts-dejavu-core \
  advancecomp pngcrush

WORKDIR "/root"

CMD ["bash"]
