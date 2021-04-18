# Set up glusterfs on the cluster

cx ssh -s 'tjpalanca.com' master01

sudo apt-get update
sudo apt-get install -y software-properties-common
sudo add-apt-repository ppa:gluster/glusterfs-7
sudo apt update
sudo apt install glusterfs-server
sudo systemctl status glusterd.service

sudo gluster peer status

sudo gluster volume create tjpalanca master01.tjpalanca-com.c66.me:/mnt/gluster force
sudo gluster volume start tjpalanca
sudo gluster volume status

sudo apt install glusterfs-client
sudo mkdir /mnt/storage

sudo mount -t glusterfs master01.tjpalanca-com.c66.me:tjpalanca /mnt/storage

sudo su
echo 'master01.tjpalanca-com.c66.me:/tjpalanca /mnt/storage glusterfs defaults,_netdev 00' >> /etc/fstab
exit

exit

cx ssh -s 'tjpalanca.com' kube01

sudo apt-get update
sudo apt-get install -y software-properties-common
sudo add-apt-repository ppa:gluster/glusterfs-7

sudo apt-get update
sudo apt install -y glusterfs-client
sudo mkdir /mnt/storage

sudo mount -t glusterfs master01.tjpalanca-com.c66.me:tjpalanca /mnt/storage

sudo su
echo 'master01.tjpalanca-com.c66.me:/tjpalanca /mnt/storage glusterfs defaults,_netdev 00' >> /etc/fstab
exit

exit
