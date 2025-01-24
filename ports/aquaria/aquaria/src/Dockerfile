FROM ubuntu:focal

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update

RUN apt install -y --no-install-recommends \
        sudo whiptail ca-certificates apt-utils nano wget curl

RUN apt install -y --no-install-recommends \
        build-essential git make pkg-config cmake ninja-build 

RUN apt install -y --no-install-recommends \
        libopenal-dev libsdl2-dev

RUN apt install -y --no-install-recommends \
        ccache zip lsb-release imagemagick

# newer version of gcc
RUN apt install -y gcc-10 g++-10

# cmake
RUN wget https://github.com/Kitware/CMake/releases/download/v3.31.3/cmake-3.31.3-linux-`uname -m`.sh
RUN chmod a+x ./cmake-3.31.3-linux-`uname -m`.sh
RUN ./cmake-3.31.3-linux-`uname -m`.sh --prefix=/usr/local --exclude-subdir --skip-license

CMD ["bash"]
