# TJCloud

<!-- badges: start -->
[![Deploy KeyCloak to TJCloud](https://github.com/tjpalanca/tjcloud/actions/workflows/deploy_keycloak.yml/badge.svg)](https://github.com/tjpalanca/tjcloud/actions/workflows/deploy_keycloak.yml)
[![Deploy RStudio to TJCloud](https://github.com/tjpalanca/tjcloud/actions/workflows/deploy_rstudio.yml/badge.svg)](https://github.com/tjpalanca/tjcloud/actions/workflows/deploy_rstudio.yml)
[![Deploy VS Code to TJCloud](https://github.com/tjpalanca/tjcloud/actions/workflows/deploy_vscode.yml/badge.svg)](https://github.com/tjpalanca/tjcloud/actions/workflows/deploy_vscode.yml)
[![ShinyProxy Deployment](https://github.com/tjpalanca/tjcloud/actions/workflows/deploy_shinyproxy.yml/badge.svg)](https://github.com/tjpalanca/tjcloud/actions/workflows/deploy_shinyproxy.yml)
<!-- badges: end -->

TJCloud is composed of cloud environments that allow me to use Chromebooks as my
primary computing solution for data science and software development.

The stack is deployed on a simple Kubernetes cluster, with each individual part
served through virtual hosts in NGINX.

## RStudio

The RStudio development environment builds on the `rocker/geospatial` docker
image, and adds:

* Docker and Docker Compose for building dockerized applications 
* `kubectl` for controlling the Kubernetes cluster
* Cloud66 Toolbelt which is the provisioning service for Kubernetes
* Git Large File Storage
* Anaconda for managing Python Environments
* Google Chrome for headless browsing.

## VS Code 

The VS Code builds on the RStudio image (to keep using Ubuntu as the base
operating system) and adds:

* Julia 
* `code-server` which is an open source web based port of VS Code.

## Crostini

Chromebooks come with linux containers through crostini. These scripts allow
me to set up a docker environment for local development on a Chromebook.

## Infrastructure

Infrastructure for monitoring and adding the Kubernetes Dashboard to the 
cluster for easy and quick management.

## Keycloak

Keycloak provides identity and access management for my cloud. I add some 
custom login themes here.

## ShinyProxy

ShinyProxy is a really easy way of deploying dockerized Shiny applications and
allowing provisioned access to it.
