#!/bin/sh
rpm -qa libmcrypt-devel |grep "libmcrypt-devel" &>/dev/null
if [ $? -eq 0 ];then
	echo "0000000000000000000000"
	echo "ok!"
	exit 1;
else 
	wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-6.repo
	yum -y install libmcrypt-devel
	exit 0;
fi
