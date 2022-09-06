#!/usr/bin/bash

curl -fsSL https://install.julialang.org >> juliaup-init
chmod +x juliaup-init
./juliaup-init -y
rm ./juliaup-init
