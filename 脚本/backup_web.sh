#!/bin/bash
#by jinc
#sure you are root
if [ $(id -u) != "0"  ]
then
echo "you not root, bye"
exit 1
fi
#path
#hostname=`cat /etc/sysconfig/network|awk -F "[=]" 'NR==2 {print $2}'`
hostname=`hostname`
hostname1=web01
#IP=`ifconfig eth1 |awk -F "[ :]+" 'NR==2 {print $4}'`
IP=`hostname -I|awk '{print $2}'`
Path="/backup/$IP"
[ ! -d $Path ] && mkdir $Path -p
#hostname=web
if [ `cat /etc/sysconfig/network|awk -F "[=]" 'NR==2 {print $2}'` = "$hostname1" ]
then
echo "this is $hostname:$IP"
mkdir -p /var/html/www /app/logs
#backup
cd / && \
tar zcfP $Path/conf_$(date +%F).tar.gz var/spool/cron/root etc/rc.local etc/sysconfig/iptables server/scripts &&\
tar zcfP $Path/logs_$(date +%F).tar.gz app/logs/ &&\
tar zcfP $Path/www_$(date +%F).tar.gz /var/html/www/ &&\
touch $Path/flag_$(date +%F)

#md5
find /backup/ -type f -name "*$(date +%F).tar.gz" |xargs md5sum >/$Path/flag_$(date +%F)
#to backup server

echo "123456" >/etc/rsync.password
psfile=/etc/rsync.password
chmod 600 $psfile
rsync -az /backup/ rsync_backup@172.16.1.41::backup --password-file=/etc/rsync.password
#rm
find /backup -type f -name "*.tar.gz" -mtime +7|xargs rm -rf
else
echo "this is $hostname:$IP"
echo "123456" >/etc/rsync.password
psfile=/etc/rsync.password
chmod 600 $psfile
tar zcfP $Path/conf_$(date +%F).tar.gz /var/spool/cron/root /etc/rc.local /etc/sysconfig/iptables /server/scripts &&\
touch $Path/flag_$(date +%F)

#md5
find /backup/ -type f -name "*$(date +%F).tar.gz" |xargs md5sum >/$Path/flag_$(date +%F)
#to backup server
rsync -az /backup/ rsync_backup@172.16.1.41::backup --password-file=/etc/rsync.password
#del
/bin/find /backup -type f -name "*.tar.gz" -mtime +180|xargs rm -f
fi

