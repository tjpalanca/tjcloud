## Terraform Migration

### Immediate Migration 

- [x] Move to Linode, it's cheaper (presumably this is one of the benefits of using terraform so this better be useful!
    - [x] Get Kubernetes provider to receive those credentials 
    - [x] Terraform was quite good
- [x] Set up some non-hack to enable persistent storage on pods
    - [x] Kubernetes PVCs in DigitalOcean
        - [x] Two shared PVCs with same volume name
            - Doesn't work, the PVC stays there indefinitely
            - Any further and it gets too hacky for my taste
    - [x] Setting up an NFS store within Kubernetes
        - https://github.com/openebs/dynamic-nfs-provisioner/blob/develop/docs/intro.md
        - Decided against this - this is too much overhead for a simple cluster
        - Reconsidering this again, if I'm considering Rook Ceph NFS this might be simpler
        - Nah this is marked as beta
    - [x] Setting up a droplet to serve as storage
        - Cost will be a factor
        - Also decided against this, slow disk for not much gain
    - [x] Just using separate PVCs for everything
        - Won't this inhibit sharing data?
            _ I am relatively sure the answer is yes.
            - Reason why I'm not doing it.
    - [x] Trying a configmap for these files
        - Configmaps are read only
    - [x] Mount volumes using terraform and use `local` PersistentVolume type
        - Need to verify if it actually works by SSHing into the boxes and verifying.
        - OK, so it isn't actually mounting automatically.
            - Let me try if I can mount it from a pod automatically.
                - Seems too difficult and kind of a hack 
        - I'm abandoning this as I don't think it's feasible.
    - [x] Use Rook Ceph NFS 
        - still too complex 
    - [x] WORKING - Use Terraform Provisioners to mount volumes to cluster
        - Was able to get the root password reset via the Linode API so we can access 
        - Was also able to ssh in and mount the filesystem from the device
        - [x] Need to grant SSH keys access - done via a provisioner
        - [x] Need to avoid mounting the filesystem if it's not there
        - [x] Automount
        - [x] Ended up using `hostPath` and `nodeSelector` for simplicity.
- [x] Allow for easy resizing without recreating the cluster
    - Have 2 node pools for this production and development. To resize we just kill
      or replace the development node pool. I don't expect to resize the production 
      one, or we can just add another production node pool.
    - Linode solves this problem, no need for 2 node pools.
- [x] Add main postgres instance 
    - [x] Expose it to the outside world so I can use other SQL clients and to Terraform?
        - Using a NodePort
        - [x] Set up SSL
- [x] Add ingress
- [x] Set up keycloak
    - Having an issue where there is mixed content, I suspect it's because cloudflare is 
      proxying HTTPS so the ingress and keycloak don't know that they should serve 
      paths at HTTPS
    - [x] Fixed by adding an origin certificate for nginx ingress to use
    - [x] Authenticate keycloak provider 
    - [x] Build custom docker image with keycloak themes
    - [x] Set up identity providers
- [x] Set up pgadmin with proxy
    - [x] Set up a gateway resource that created the proxy and ingress
    - [x] Niftily you can use terraform to link client IDs, making it very convenient 
    - On the NGINX config for Keycloak, you need to enable CORS 
    - Need to disabled enhanced cookie protection because IPs can be dynamic from cloudflare
- [x] Deploy code-server
    - [x] GPG Signing commits
        - Just need to follow the instructions, adding setting to gpg-agent.conf to 
          have TTL be 1 hour makes it more convenient
- [x] Add node problem detector
    - Aborted; not really practical
- [x] Enable Linode LongView for monitoring memory
    - Aborted; no easy way to integrate this as not included in Terraform provider
- [x] Add image caching for Kaniko
- [x] Enable real IP despite CloudFlare
    - Added settings to the configmap to take cloudflare origin ips and trust real ips coming from those origins (amazing!)
- [x] Use 1Password CLI
- [x] Use 1Password Connect Server
    - Not practical for personal use
- [x] Image should wait until build
    - Changing the kaniko pod to a job allows terraform provider to wait for completion
- [x] Set up Plausible Analytics 
    - Modified the `application` module to allow resource limits, run as user
    - Set up mail server
- [x] Fix thrashing for the realm_id
    - stopped referencing realm not by the ID
- [x] Fix thrashing for the cloudflare zone
    - moving to a static value instead of a variable didn't fix it, it seems we need to fix the lifecycle? 
    - decided to just move the zone name to a variable as well
    - K8s deployments still applied but because of K8s it's just cosmetic and won't actually redeploy services
- [x] Fix image not updating deployment
    - If image version left blank, then version number will be the hash
- [x] Expose Kubernetes Dashboard at system
    - Had to add the metrics-server and the dashboard itself proxied with a gateway
- [x] Add font handling for the code-server instance
- [x] Move object storage to Linode
    - Same trick as digitalocean, change the endpoints. I did notice that uploading was
      much slow than the downloading, not sure if that's S3 or just Linode.
- [x] Set up cloudflare authenticated origin pulls

### Future Improvements

- [ ] Entering Kubernetes network - useful for accessing databases, hold for now
- [ ] Set up dagster / tjjobs to restore smart home automation
- [ ] Fully manage cloudflare zone
- [ ] Fully manage namecheap domain
- [ ] Knative Serving for scaling down to zero when not in use