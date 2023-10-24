FROM ubuntu:latest

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      wget \
      gcc g++ \
      libgmp-dev \
      libhwloc-dev \
      libpmix-dev \
      libucx-dev ucx-utils \
      libfabric-dev libfabric-bin \
      && \
    apt-get autoremove --purge -y && \
    apt-get autoclean -y && \
    rm -rf /var/cache/apt/* /var/lib/apt/lists/*

WORKDIR /tmp
RUN wget https://www.mpich.org/static/downloads/4.1.2/mpich-4.1.2.tar.gz && \
    tar xvf mpich-4.1.2.tar.gz && cd mpich-4.1.2 && \
    ./configure \
      --prefix=/opt/apps/mpich/4.1.2 \
      --with-libfabric=/usr \
      --with-slurm=/usr \
      --with-device=ch4:ucx \
      --with-pm=hydra \
      --with-hwloc=/usr \
      --with-pmix=/usr/lib/x86_64-linux-gnu/pmix2 \
      --enable-shared \
      --without-yaksa \
      &&\
    make -j && make install && \
    rm -rf /tmp/*
