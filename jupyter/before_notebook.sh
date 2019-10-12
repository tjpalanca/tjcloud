#! /bin/bash

# Export NB_USER
export NB_USER=$(echo $NB_USER)

# Give nb user docker permissions
sudo usermod -aG docker $NB_USER
