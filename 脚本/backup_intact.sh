#!/bin/bash
#this is a script foe backup 
#include server and client
#by jinc
function usage () {
	echo "USAGE: $0 {1|2|3|}"
	exit 1
}
function menu () {
	cat <<END
	1.you are server
	2.you are client
	3.check and e-mail
END
}
function chose () {
read -p "pls tell me who are you: " select
case "$select" in 
	1)
if [ $(id -u) != "0"  ]
then
echo "you not root, bye"
exit 1
else
echo "you are root,you can go on"
fi
echo "Wait for 3 seconds"
sleep 1
for((i=2;i>0;i--));do
echo -e "$i\r"
sleep 1
done
#true rsync is in your server
rpm -qa rsync 
if [ $? -eq 0 ]
then
echo "rsync is in you server, go on"
else
echo "i will help you install rsync"
yum install -y rsync
fi
echo "Wait for 2 seconds"
sleep 1
for((i=2;i>0;i--));do
echo -e "$i\r"
sleep 1
done
#writr rsyncd.conf
cat >/etc/rsyncd.conf<< EOF
uid = rsync
gid = rsync
use chroot = no
max connections = 200
timeout = 300
pid file = /var/run/rsyncd.pid
lock file = /var/run/rsync.lock
log file = /var/log/rsyncd.log
ignore errors
read only = false
list = false
hosts allow = 172.16.1.0/24
hosts deny = 0.0.0.0/32
auth users = rsync_backup,jinc
secrets file = /etc/rsync.password
[backup]
comment = "backup dir by oldboy"
path = /backup
EOF
echo "the configuration file is writen ,go on"
echo "Wait for 2 seconds"
sleep 1
for((i=2;i>0;i--));do
echo -e "$i\r"
sleep 1
done
#add a user
id rsync
if [ $? -ne 0 ]
then
useradd -M -s /sbin/nologin rsync
echo "virtual user is add"
else
echo "user rsync is exists,do not add again"
fi
echo "Wait for 3 seconds"
sleep 1
for((i=2;i>0;i--));do
echo -e "$i\r"
sleep 1
done
#create backup dir && chmod
if [ ! -d /backup ]
then
mkdir /backup -p
fi
chown -R rsync.rsync /backup
echo "dir /backup is create and Authorization has been modified"
echo "Wait for 3 seconds"
sleep 1
for((i=2;i>0;i--));do
echo -e "$i\r"
sleep 1
done
#Create an authenticated user password file
file=/etc/rsyncd.password
if [ ! -f $file ]
then
touch $file
fi
echo "rsync_backup:123456" >>$file && chmod 600 $file
echo "file $file is create and Authorization has been modified"
echo "Wait for 3 seconds"
sleep 1
for((i=2;i>0;i--));do
echo -e "$i\r"
sleep 1
done
#start rsync
rsync --daemon
if [ $? -eq 0 ]
then
echo "rsync server is start,now you can use it "
else
killall rsync && rsync --daemon
fi
for((i=2;i>0;i--));do
echo -e "$i\r"
sleep 1
done
echo "Installation completed,wish you hava a good time "
	;;
	2)
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
	;;
	3)
if [ $(id -u) != "0"  ]
then
echo "you not root, bye"
exit 1
fi
#true rsync is in your server
rpm -qa rsync
if [ $? -eq 0 ]
then
echo "rsync is in you server,you can go on"
else
echo "i will help you install rsync"
yum install -y rsync
fi
#true rsync service is start ok
rsync --daemon
if [ $? -eq 0 ]
then
echo "rsync server is start"
else
killall rsync && rsync --daemon
fi
#save
day=`date +%w`
if [ $day -eq 1 ]
then
tar zcfP /backup/date_$(date +%F_%w).tar.gz /backup/* && cp /backup/date_$(date +%F_%w).tar.gz /tmp/
else
echo "sorry,today is `date +%F_%w`"
fi
#check 
find /backup -type f -name "flag_$(date +%F)" |xargs md5sum -c  >/opt/mail_body_$(date +%F).txt
#send mail
mail -s "$(date +%F_%T) back" 664341340@qq.com  </opt/mail_body_$(date +%F).txt
if [ $? -eq 0 ]
then
echo "mail is send ok"
else
echo "mail send error!!!you need send again"
fi
	;;
	*)
	usage
esac	
}
#main
function main() {
	menu
	chose
}
main
