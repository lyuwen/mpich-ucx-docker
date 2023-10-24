FROM ubuntu:latest

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      wget ca-certificates \
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

ENV MPICH_DIR=/opt/apps/mpich/4.1.2
ENV PATH=$MPICH_DIR/bin:$PATH \
    LD_LIBRARY_PATH=$MPICH_DIR/lib:$LD_LIBRARY_PATH \
    LIBRARY_PATH=$MPICH_DIR/lib:$LIBRARY_PATH \
    CPATH=$MPICH_DIR/include:$CPATH \
    MANPATH=$MPICH_DIR/share/man:$MANPATH \
    MPI_BIN=$MPICH_DIR/bin \
    MPI_SYSCONFIG=$MPICH_DIR/etc \
    MPI_LIB=$MPICH_DIR/lib \
    MPI_INCLUDE=$MPICH_DIR/include \
    MPI_MAN=$MPICH_DIR/man \
    MPI_COMPILER=mpich-x86_64 \
    MPI_SUFFIX=_mpich \
    MPI_HOME=$MPICH_DIR

WORKDIR /tmp
RUN wget https://www.mpich.org/static/downloads/4.1.2/mpich-4.1.2.tar.gz && \
    tar xvf mpich-4.1.2.tar.gz && cd mpich-4.1.2 && \
    ./configure --with-device=ch4:ucx --prefix=/opt/apps/mpich/4.1.2 && \
    make && make install && \
    rm -rf /tmp/*

RUN mkdir -p /work
WORKDIR /work
