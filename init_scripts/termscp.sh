#!/usr/bin/env bash

# Dependencies
apt-get install -y \
  libavahi-client3 \
  libavahi-common-data \
  libavahi-common3 \
  libldb2 \
  liblmdb0 \
  libpopt0 \
  libsmbclient0 \
  libtalloc2 \
  libtdb1 \
  libtevent0t64 \
  libwbclient0 \
  samba-libs

curl --proto '=https' --tlsv1.2 -sSLf "https://git.io/JBhDb" | bash -s -- -y
