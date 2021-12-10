#!/usr/bin/bash

export R_VERSION=4.1.2
export R_HOME=/usr/local/lib/R
export CRAN=https://packagemanager.rstudio.com/cran/__linux__/focal/291
/scripts/install_R_ppa.sh
/scripts/patch_install_command.sh
/install/radian.sh