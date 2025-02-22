#!/bin/bash

apt install -y pass

git clone https://github.com/tadfisher/pass-otp
cd pass-otp || exit
make install || exit
cd .. || exit
rm -rf pass-otp
