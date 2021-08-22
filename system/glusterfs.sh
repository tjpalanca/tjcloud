# Set up glusterfs on the cluster

cx ssh -s 'tjcloud' master

sudo apt-get update
sudo apt-get install -y software-properties-common
sudo add-apt-repository ppa:gluster/glusterfs-7
sudo apt-get update
sudo apt install glusterfs-server
sudo systemctl status glusterd.service

sudo gluster peer status

sudo gluster volume create storage master.tjcloud.c66.me:/mnt/brick01/ force
sudo gluster volume start storage
sudo gluster volume status

sudo apt install glusterfs-client
sudo mkdir /mnt/storage

sudo mount -t glusterfs master.tjcloud.c66.me:storage /mnt/storage

sudo su
echo 'master.tjcloud.c66.me:/storage /mnt/storage glusterfs defaults,_netdev 0 0' >> /etc/fstab
exit

exit

cx ssh -s 'tjcloud' dev01

sudo apt-get update
sudo apt-get install -y software-properties-common
sudo add-apt-repository ppa:gluster/glusterfs-7

sudo apt-get update
sudo apt install -y glusterfs-client
sudo mkdir /mnt/storage

sudo mount -t glusterfs master.tjcloud.c66.me:storage /mnt/storage

sudo su
echo 'master.tjcloud.c66.me:/storage /mnt/storage glusterfs defaults,_netdev 0 0' >> /etc/fstab
exit

exit
