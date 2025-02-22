#!/bin/bash
VERSION=$(curl -s "https://api.github.com/repos/Orange-OpenSource/hurl/releases/latest" | \grep -Po '"tag_name": *"\K[^"]*')

apt-add-repository -y ppa:lepapareil/hurl
apt install hurl="${VERSION}"*
