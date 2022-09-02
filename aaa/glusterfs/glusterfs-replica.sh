cx ssh -s 'tjcloud' dev01

sudo apt-get install -y software-properties-common
sudo add-apt-repository ppa:gluster/glusterfs-7
sudo apt-get update
sudo apt install glusterfs-server
sudo systemctl status glusterd.service

exit

cx ssh -s 'tjcloud' master

sudo gluster peer probe dev01.tjcloud.c66.me
sudo mkdir /mnt/arbiter01

sudo umount /mnt/storage
sudo mount -t glusterfs localhost:storage /mnt/storage

exit

cx ssh -s 'tjcloud' dev01

sudo gluster peer status
sudo gluster volume list
sudo gluster volume add-brick storage replica 2 dev01.tjcloud.c66.me:/mnt/brick02/ force
sudo gluster volume add-brick storage replica 3 arbiter 1 master.tjcloud.c66.me:/mnt/arbiter01 force

sudo umount /mnt/storage
sudo mount -t glusterfs localhost:storage /mnt/storage

sudo gluster volume rebalance storage start

exit

