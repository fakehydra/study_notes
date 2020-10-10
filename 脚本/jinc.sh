#!/bin/bash
#this is a script foe backup 
#include server and client
#by jinc
function usage () {
	echo "USAGE: $0 {1|2|3|4|5|}"
	exit 1
}
function menu () {
	cat <<END
	1.rsync server
	2.rsync client
	3.rsync-check and e-mail
	4.linux 优化
	5.ftp
	Press any key to exit
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
	4)
#yum源优化
mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup &&\
wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-6.repo 
mv /etc/yum.repos.d/epel.repo /etc/yum.repos.d/epel.repo.backup &&\
wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-6.repo
#1、关闭selinux
sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config
grep SELINUX=disabled /etc/selinux/config 
setenforce 0
getenforce
sleep 2
#2、关闭iptables 
/etc/init.d/iptables stop
/etc/init.d/iptables stop
chkconfig iptables off
sleep 2
#3、精简开机自启动服务
chkconfig|egrep -v "crond|sshd|network|rsyslog|sysstat"|awk '{print "chkconfig",$1,"off"}'|bash
export LANG=en
chkconfig --list|grep 3:on
sleep 2
#4、提权oldboy可以sudo (可选项)
useradd oldboy
echo 123456|passwd --stdin oldboy
\cp /etc/sudoers /etc/sudoers.ori
echo "oldboy  ALL=(ALL) NOPASSWD: ALL " >>/etc/sudoers
tail -1 /etc/sudoers
visudo -c
sleep 2
#5、中文字符集
#cp /etc/sysconfig/i18n /etc/sysconfig/i18n.ori
#echo 'LANG="zh_CN.UTF-8"'  >/etc/sysconfig/i18n 
#source /etc/sysconfig/i18n
#echo $LANG

#6、时间同步
echo '#time sync by jinc at 2018-08-x)' >>/var/spool/cron/root
echo '* 12 * * * /usr/sbin/ntpdate ntp.api.bz >/dev/null 2>&1' >>/var/spool/cron/root
ntpdate
if [ $? -ne 0 ]
then
	yum install -y ntpdate
else
echo "ntpdate is on your computer"
fi
echo "/usr/sbin/ntpdate ntp.api.bz >>/etc/rc.local"
sleep 2
#7、命令行安全  (一定不要优化)
#echo 'export TMOUT=300' >>/etc/profile
#echo 'export HISTSIZE=5' >>/etc/profile
#echo 'export HISTFILESIZE=5' >>/etc/profile
#tail -3 /etc/profile
#. /etc/profile

#8、加大文件描述
echo '*               -       nofile          65535 ' >>/etc/security/limits.conf 
tail -1 /etc/security/limits.conf 
# 确保服务程序可以正常运行

#9、内核优化
cat >>/etc/sysctl.conf<<EOF
net.ipv4.tcp_fin_timeout = 2
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_tw_recycle = 1
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_keepalive_time = 600
net.ipv4.ip_local_port_range = 4000    65000
net.ipv4.tcp_max_syn_backlog = 16384
net.ipv4.tcp_max_tw_buckets = 36000
net.ipv4.route.gc_timeout = 100
net.ipv4.tcp_syn_retries = 1
net.ipv4.tcp_synack_retries = 1
net.core.somaxconn = 16384
net.core.netdev_max_backlog = 16384
net.ipv4.tcp_max_orphans = 16384
#以下参数是对iptables防火墙的优化，防火墙不开会提示，可以忽略不理。
net.nf_conntrack_max = 25000000
net.netfilter.nf_conntrack_max = 25000000
net.netfilter.nf_conntrack_tcp_timeout_established = 180
net.netfilter.nf_conntrack_tcp_timeout_time_wait = 120
net.netfilter.nf_conntrack_tcp_timeout_close_wait = 60
net.netfilter.nf_conntrack_tcp_timeout_fin_wait = 120
EOF
sleep 2
#10. 下载安装系统基础软件
yum install lrzsz nmap tree dos2unix nc -y
===================================================
#hosts解析
cat >/etc/hosts<<EOF
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
172.16.1.5      lb01
172.16.1.6      lb02
172.16.1.7      web01
172.16.1.8      web02
172.16.1.9      web03
172.16.1.51     db01 db01.etiantian.org
172.16.1.31     nfs01
172.16.1.41     backup
172.16.1.61     m01
EOF
	;;
	5)
nu=`rpm -qa vsftpd|wc -l`
if [ $nu -ne 0 ]
then
echo "vsftpd is on you computer,go on next"
else
echo "vsftpd is not in your computer ,i will install it now "
sleep 2
yum install -y vsftpd 
sleep 1
echo "install finisf"
fi
#create a dir for up down
if [ ! -d /home/uftp ]
then
mkdir -p /home/uftp && chmod 777 /home/uftp 
fi
sleep 1
echo "/home/uftp is used to up down"
sleep 2
#add a user to ftp
id uftp
if [ $? -ne 0 ]
then
useradd -d /home/uftp/ -s /bin/bash uftp && echo "123456" |passwd --stdin uftp
else
echo "user uftp is exists"
fi
#vsftpd.conf
file=/etc/vsftpd.conf
if [ ! -f $file ]
then
touch $file
fi
cat>>/etc/vsftpd.conf<<EOF
userlist_deny=no
userlist_enable=yes
userlist_file=/etc/allowed_users
seccomp_sandbox=no
EOF

sed -i.bak 's/#write_enable=YES/write_enable=YES/g' /etc/vsftpd.conf
#add the login user file
echo "uftp" >/etc/allowed_users
#add blacklist
file1=/etc/ftpusers
if [ ! -f $file1 ]
then
touch $file1
else
echo "$file1 is on you computer"
fi
sleep 2
cat >>/etc/ftpusers<<EOF
root
daemon
bin
sys
sync
games
man
lp
mail
news
uucp
nobody
EOF
sleep 1
#restart
service vsftpd restart
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
while true
do
main
done
