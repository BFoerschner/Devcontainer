#!/usr/bin/env bash

git clone https://github.com/eradman/entr.git && cd entr || exit
./configure
make install
cd .. || exit
rm -rf ./entr/
