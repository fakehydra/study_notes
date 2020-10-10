#!/bin/sh
rpm -qa libmcrypt-devel |grep "libmcrypt-devel" &>/dev/null
if [[ $? -ne 0 ]]; then
	wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-6.repo	
	yum -y install libmcrypt-devel
	exit 1;
else
	echo "ni  yi  jing  you  le !"
	exit 0;
fi