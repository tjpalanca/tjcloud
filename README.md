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
