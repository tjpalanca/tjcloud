#!/usr/bin/bash

pip3 install -U jupyter jupyterlab
apt-get update && apt-get install -y libzmq3-dev
Rscript -e "install.packages('IRkernel')"
Rscript -e "IRkernel::installspec()"