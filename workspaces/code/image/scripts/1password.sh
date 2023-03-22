#!/usr/bin/bash

curl -sSfo op.zip \
  https://cache.agilebits.com/dist/1P/op2/pkg/v2.0.0/op_linux_amd64_v2.0.0.zip \
  && unzip -od /usr/local/bin/ op.zip \
  && rm op.zip
