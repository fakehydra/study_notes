yum install -y nfs-utils rpcbind 
/etc/init.d/rpcbind start
/etc/init.d/nfs start
#echo /data 10.0.0.0/24(insecure,rw,async,no_root_squash)>>/etc/exports
#/etc/init.d/nfs reload
showmount -e 10.0.0.203
mount -t nfs 10.0.0.203:/data /mnt 
df -h