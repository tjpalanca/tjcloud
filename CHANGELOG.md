# Release notes

<!-- do not remove -->

## 2.2.0 - Security Hardening and `{nbdev}`

* Added a Linode Cloud Firewall to protect from opportunistic and brute force attacks.
* Moved Terraform orchestration to GitHub Actions to allow opening up the firewall 
  during deploys from Terraform Cloud 
* Moved documentation to `{nbdev}` and to develop Python scripts used to disable and 
  re-enable the firewall, along with the relevant github actions workflows and utilities
  that come with the standard development workflow in `{tjutils} 
* Disable `code-server` custom welcome page 
