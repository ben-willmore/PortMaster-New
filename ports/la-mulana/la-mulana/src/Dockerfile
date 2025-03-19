FROM debian:bullseye

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update

RUN apt install -y --no-install-recommends \
        ca-certificates apt-utils nano wget \
        lsb-release

RUN apt install -y --no-install-recommends \
        build-essential

RUN apt install -y \
  libsdl2-dev libconfig-dev zip

WORKDIR "/root"

CMD ["bash"]
