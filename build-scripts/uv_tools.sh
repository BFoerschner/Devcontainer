#!/usr/bin/env bash

install_uv_tools() {
  uv tool install 'harlequin[postgres,mysql,s3]' --force
  uv tool install 'httpie' --force
  uv tool install 'jrnl' --force
  uv tool install 'visidata' --force
  uv tool install 'mitmproxy' --force
  uv tool install 'ansible' --force
  uv tool install 'ansible-core' --force
  uv tool install 'stringshift [full]' --force
}
