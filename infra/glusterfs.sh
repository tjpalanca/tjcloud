# Set up glusterfs on the cluster

cx ssh -s 'tjpalanca' master

sudo apt-get update
sudo apt-get install -y software-properties-common
sudo add-apt-repository ppa:gluster/glusterfs-7
sudo apt update
sudo apt install glusterfs-server
sudo systemctl status glusterd.service

sudo gluster peer status

sudo gluster volume create storage master.tjpalanca.c66.me:/mnt/storage01 force
sudo gluster volume start storage
sudo gluster volume status

sudo apt install glusterfs-client
sudo mkdir /mnt/storage

sudo mount -t glusterfs localhost:storage /mnt/storage

sudo su
echo 'localhost:/storage /mnt/storage glusterfs defaults,_netdev 00' >> /etc/fstab
exit

exit

cx ssh -s 'tjpalanca' dev01

sudo apt-get update
sudo apt-get install -y software-properties-common
sudo add-apt-repository ppa:gluster/glusterfs-7

sudo apt-get update
sudo apt install -y glusterfs-client
sudo mkdir /mnt/storage

sudo mount -t glusterfs master.blechnum.apn:storage /mnt/storage

sudo su
echo 'master.blechnum.apn:storage:/storage /mnt/storage glusterfs defaults,_netdev 00' >> /etc/fstab
exit

exit
