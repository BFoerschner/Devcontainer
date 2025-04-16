#!/usr/bin/env bash

# Install the HashiCorp GPG key.
wget -O- https://apt.releases.hashicorp.com/gpg |
  gpg --dearmor |
  tee /usr/share/keyrings/hashicorp-archive-keyring.gpg >/dev/null

# Verify the key's fingerprint.
gpg --no-default-keyring \
  --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
  --fingerprint

# should look like this
#
# /usr/share/keyrings/hashicorp-archive-keyring.gpg
# -------------------------------------------------
# pub   rsa4096 XXXX-XX-XX [SC]
# AAAA AAAA AAAA AAAA
# uid           [ unknown] HashiCorp Security (HashiCorp Package Signing) <security+packaging@hashicorp.com>
# sub   rsa4096 XXXX-XX-XX [E]

# Add the official HashiCorp repository to your system. The lsb_release -cs command finds the
# distribution release codename for your current system, such as buster, groovy, or sid.
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com $(lsb_release -cs) main" |
  tee /etc/apt/sources.list.d/hashicorp.list

# Download the package information from HashiCorp and install terraform
apt-get update && apt-get install -y terraform
