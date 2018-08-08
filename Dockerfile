FROM ubuntu:xenial
MAINTAINER John Garza <johnegarza@wustl.edu>

LABEL \
    description="Image supporting the varscan_germline.cwl tool"

RUN apt-get update -y && apt-get install -y \
    apt-utils \
    bzip2 \
    default-jre \
    g++ \
    libbz2-dev \
    liblzma-dev \
    make \
    ncurses-dev \
    wget \
    zlib1g-dev

#install varscan

ENV VARSCAN_INSTALL_DIR=/opt/varscan

WORKDIR $VARSCAN_INSTALL_DIR
RUN wget https://github.com/dkoboldt/varscan/releases/download/2.4.2/VarScan.v2.4.2.jar && \
    ln -s VarScan.v2.4.2.jar VarScan.jar

#install samtools

ENV SAMTOOLS_INSTALL_DIR=/opt/samtools

WORKDIR /tmp
RUN wget https://github.com/samtools/samtools/releases/download/1.7/samtools-1.7.tar.bz2 && \
  tar --bzip2 -xf samtools-1.7.tar.bz2

WORKDIR /tmp/samtools-1.7
RUN ./configure --enable-plugins --prefix=$SAMTOOLS_INSTALL_DIR && \
  make all all-htslib && \
  make install install-htslib

WORKDIR /
RUN ln -s $SAMTOOLS_INSTALL_DIR/bin/samtools /usr/bin/samtools && \
  rm -rf /tmp/samtools-1.7

#copy helper script into container
COPY varscan_germline_helper.sh /usr/bin/varscan_germline_helper.sh
