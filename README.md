# TJCloud

This is my personal cloud - for hobby programming, personal projects, and experiments. It uses a few core technologies:

* [Terraform](https://www.terraform.io) (and [Terraform Cloud](https://app.terraform.io/)) for provisioning infrastructure as code,
* [Kubernetes](https://kubernetes.io) for orchestrating various workloads, with a few general patterns:
    * [NGINX Ingress](https://kubernetes.github.io/ingress-nginx/) for exposing web services to the web from the cluster
    * Databases as stateful deployments 
    * [Keycloak](https://www.keycloak.org) for identity and access management 
    * [OAuth2 Proxy](https://oauth2-proxy.github.io/oauth2-proxy/) as main gateway to protect private services
    * [Kaniko](https://github.com/GoogleContainerTools/kaniko) for building images inside a Kubernetes cluster
* [Linode Kubernetes Engine](https://www.linode.com/products/kubernetes/), a simple, developer-friendly, and inexpensive cloud provider for managed Kubernetes, and 
* [Linode Object Storage](https://www.linode.com/products/object-storage/) for storing data files
* [Cloudflare](https://www.cloudflare.com) for DNS, TLS, and all-around protection. Some key features are:
    * Everything proxied through cloudflare network 
    * Origin certificate presented to cloudflare
    * Cloudflare sends client certificate and server verifies
* [GitHub Packages](https://github.com/features/packages) as my main image registry

As of this writing, I host the following applications:

* a VS Code instance from [code-server](https://github.com/coder/code-server) that allows me to develop on the cloud, with any device (including iPads and chromebooks!). Some special features are: 
    * Protected domains (https://\<port\>.\<domain\>) to test web apps running on the server or for exposing environments like Jupyter or Pluto
    * Custom web fonts through an NGINX sub_filter 
    * Python, Julia, JS, and R installations for the confused data person 
* [PGAdmin](https://www.pgadmin.org), an excellent open source administration console for PostgreSQL 
* [PostgreSQL](https://www.postgresql.org) for my main database, and [Clickhouse](https://clickhouse.com) as a requirement for plausible
* [Plausible Analytics](https://plausible.io) for hosting privacy-friendly website analytics
* the [Kubernetes Dashboard](https://github.com/kubernetes/dashboard) for administering the cluster, and [metrics-server](https://github.com/kubernetes-sigs/metrics-server) for collecting data to present in the dashboard.
* [Mastodon](https://joinmastodon.org) - my own personal Mastodon server for interacting with the Fediverse (open source Twitter but less annoying virality and more useful, insightful content)
