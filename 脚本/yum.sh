#!/bin/sh
. /etc/init/functions
echo '
1) 安装lnmp
2) 退出
'
function yum (){
	echo " 安装epel源...."
	yum install -y epel-release &>/dev/null
	[ $? -eq 0 ] && echo "ok"

	echo "导入RPM_GPG_KEY"	
	rpm --import mysql_pubkey.asc
	[ $? -eq 0 ] && echo "ok"

	echo “导入mysql yum源”
	rpm -Uvh http://repo.mysql.com/mysql-community-release-el7-5.noarch.rpm
	[ $? -eq 0 ] && echo "ok"

	echo "导入RPM_GPG_KEY"
	rpm --import http://rpms.remirepo.net/RPM-GPG-KEY-remi
	[ $? -eq 0 ] && echo "ok"

	echo "安装php yum源"
	rpm -Uvh http://remi.mirrors.arminco.com/enterprise/remi-release-7.rpm
	[ $? -eq 0 ] && echo "ok"

	echo "导入RPM_GPG_KEY"
	rpm --import http://nginx.org/packages/keys/nginx_signing.key
	[ $? -eq 0 ] && echo "ok"

	echo "安装nginx yum源"
	rpm -Uvh http://nginx.org/packages/centos/7/noarch/RPMS/nginx-release-centos-7-0.el7.ngx.noarch.rpm
	[ $? -eq 0 ] && echo "ok"



	sed -i "/remi\/mirror/{n;s/enabled=0/enabled=1/g}" /etc/yum.repos.d/remi.repo
	sed -i "/test\/mirror/{n;n;s/enabled=0/enabled=1/g}" /etc/yum.repos.d/remi.repo
	sed -i "/php70\/mirror/{n;s/enabled=0/enabled=1/g}" /etc/yum.repos.d/remi-php70.repo
	yum clean all
	yum makecache
}
case n in
	1)
	yum
	exit
	;;
	2)
	exit 0
	;;
	*)
	echo "please input 1 or 2"
	exit 1
	;;
esac
