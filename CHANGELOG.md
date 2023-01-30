# Release notes

<!-- do not remove -->

## 2.5.0

* Migrate Mastodon to Linode Object Storage [#36](https://github.com/tjpalanca/tjcloud/issues/36)

## 2.4.1

* Upgraded NGINX Ingress Controller to v1.3.1 [#27](https://github.com/tjpalanca/tjcloud/issues/27)

## 2.4.0 - Self-Hosted RSS and Email Subscriptions

* Added FreshRSS and Kill the Newsletter to my personal server. [#22](https://github.com/tjpalanca/tjcloud/issues/22)

## 2.3.0 - Mastodon Upgrades

* Upgrade Mastodon to v4.0.2 ([#24](https://github.com/tjpalanca/tjcloud/issues/24))
* Add liveness and readiness probes ([#20](https://github.com/tjpalanca/tjcloud/issues/20))
* Move Puma to single-mode in order to reduce memory usage

## 2.2.0 - Security Hardening and `{nbdev}`

* Added a Linode Cloud Firewall to protect from opportunistic and brute force attacks.
* Moved Terraform orchestration to GitHub Actions to allow opening up the firewall 
  during deploys from Terraform Cloud 
* Moved documentation to `{nbdev}` and to develop Python scripts used to disable and 
  re-enable the firewall, along with the relevant github actions workflows and utilities
  that come with the standard development workflow in `{tjutils} 
* Disable `code-server` custom welcome page 
