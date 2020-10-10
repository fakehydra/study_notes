yum install -y nfs-utils rpcbind 
/etc/init.d/rpcbind start
/etc/init.d/nfs start
showmount -e 10.0.0.203
mount -t nfs 10.0.0.203:/data /mnt
dh -h 
