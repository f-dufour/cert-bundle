FROM ubuntu:18.04

LABEL maintainer="florent.dufour@univ-lorraine.fr"
LABEL description="Pipeline for creating and issing blockchain certificates with the Blockcerts standard"

#ARG CHAIN # regtest, tesnet, mainnet
#ARG ROSTER # The CSV file for participants

# Install required dependencies
RUN apt-get update -q \
  && apt-get upgrade -yq \
  && apt-get install -yq \
  locales \
  git \
  wget \
  vim \
  fish \
  bsdmainutils \
  build-essential \
  libtool \
  autotools-dev \
  automake \
  pkg-config \
  libssl-dev \
  libevent-dev \
  libboost-all-dev \
  libminiupnpc-dev \
  libzmq3-dev \
  uuid-dev \
  libcap-dev \
  libpcre3-dev \
  python3 \
  python3-pip \
  && rm -rf /var/lib/apt/lists/*

# config system
COPY resources/config/config.fish /root/.config/fish
#default to UTF8 character set (avoid ascii decode exceptions raised by python)
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_TYPE en_US.UTF-8
RUN locale-gen en_US.UTF-8

# Checkout bitcoin source
WORKDIR /tmp
RUN git clone --verbose https://github.com/bitcoin/bitcoin.git bitcoin/

# Install Berkley Database
RUN wget http://download.oracle.com/berkeley-db/db-4.8.30.NC.tar.gz && tar -xvf db-4.8.30.NC.tar.gz
WORKDIR /tmp/db-4.8.30.NC/build_unix
RUN mkdir -p build
RUN BDB_PREFIX=$(pwd)/build
RUN ../dist/configure --disable-shared --enable-cxx --with-pic --prefix=$BDB_PREFIX
RUN make install

# Install bitcoin
WORKDIR /tmp/bitcoin
RUN git checkout tags/v0.18.1
RUN ./autogen.sh \
  && ./configure CPPFLAGS="-I${BDB_PREFIX}/include/ -O2" LDFLAGS="-L${BDB_PREFIX}/lib/" --without-gui
RUN make && make install

# Install cert-tools
WORKDIR /tmp
RUN git clone --verbose https://github.com/blockchain-certificates/cert-tools.git cert-tools
WORKDIR /tmp/cert-tools
RUN pip3 install .
RUN mkdir -p /cert-tools
COPY resources/cert-tools /cert-tools
# Add the roster from the argument

# Install cert-issuer
WORKDIR /tmp
RUN git clone --verbose https://github.com/blockchain-certificates/cert-issuer.git cert-issuer
WORKDIR /tmp/cert-issuer
RUN pip3 install .
COPY resources/cert-issuer /cert-issuer

# Cleanup
RUN apt-get autoremove -y
RUN rm -rf /tmp/* \
  && rm -rf /root/.cache  \
  && rm -rf /var/cache/* \
  && rm -rf /var/lib/{apt,dpkg,cache,log}/

WORKDIR /
ENTRYPOINT fish
