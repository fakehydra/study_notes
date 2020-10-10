yum update
# 安装nginx源
yum localinstall http://nginx.org/packages/centos/7/noarch/RPMS/nginx-release-centos-7-0.el7.ngx.noarch.rpm
yum repolist enabled | grep "nginx*"
# 安装nginx
yum -y install nginx
# 启动并添加开机自启
service nginx start	
systemctl enable nginx.service
# 安装mysql
yum -y localinstall http://dev.mysql.com/get/mysql57-community-release-el7-7.noarch.rpm
yum repolist enabled | grep "mysql.*-community.*"
yum -y install mysql-community-server install mysql-community-devel
# 启动并添加开机自启
service mysqld start
systemctl enable mysqld.service
# 找到随机密码
grep 'temporary password' /var/log/mysqld.log >./password.txt
# 安装PHP
rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm 
rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm
yum -y install php71w php71w-fpm
yum -y install php71w-mbstring php71w-common php71w-gd php71w-mcrypt
yum -y install php71w-mysql php71w-xml php71w-cli php71w-devel
yum -y install php71w-pecl-memcached php71w-pecl-redis php71w-opcache
# 启动并添加开机自启
service php-fpm start
systemctl enable php-fpm.service