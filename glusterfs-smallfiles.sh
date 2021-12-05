# Small file reads

cx ssh -s 'tjcloud' master

sudo su

gluster volume set storage performance.cache-invalidation on
gluster volume set storage features.cache-invalidation on
gluster volume set storage performance.qr-cache-timeout 600
gluster volume set storage cache-invalidation-timeout 600

gluster volume set storage performance.cache-size 256MB
gluster volume set storage performance.cache-max-file-size 512KB

gluster volume info storage

exit

exit
