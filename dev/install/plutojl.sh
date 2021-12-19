#!/usr/bin/bash

JULIA_DEPOT_PATH="/opt/julia/local/share/julia"
mkdir -p $JULIA_DEPOT_PATH
JULIA_DEPOT_PATH=$JULIA_DEPOT_PATH julia -e 'import Pkg; Pkg.add("Pluto")'