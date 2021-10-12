# https://www.bookstack.cn/read/okd-v3.11/6e7ee7cd455344a2.md

cx ssh -s 'tjcloud' master

sudo su
gluster volume list
gluster volume set storage performance.stat-prefetch off
gluster volume set storage performance.read-ahead off
gluster volume set storage performance.write-behind off
gluster volume set storage performance.readdir-ahead off
gluster volume set storage performance.io-cache off
gluster volume set storage performance.quick-read off
gluster volume set storage performance.open-behind off
gluster volume set storage performance.strict-o-direct on

exit
exit
