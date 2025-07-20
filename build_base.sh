#!/usr/bin/env bash
set -eo pipefail

echo "Building base development image..."
docker build --build-arg INIT_SCRIPT_PATH=init_base.sh -t devel_base .
echo "Base image 'devel_base' built successfully!"