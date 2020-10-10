centos7 安装readmine 


# 环境
1.centos7
2.mysql
3.ruby
4.readmine

# 环境配置
# 安装mysql
yum -y localinstall http://dev.mysql.com/get/mysql57-community-release-el7-7.noarch.rpm
yum repolist enabled | grep "mysql.*-community.*"
yum -y install mysql-community-server mysql-community-devel
# 启动并添加开机自启
service mysqld start
systemctl enable mysqld.service
# 找到随机密码
grep 'temporary password' /var/log/mysqld.log >./password.txt
# 修改默认mysql密码
在/etc/my.cnf [mysqld] 后面添加一行：skip-grant-tables  //不输入密码直接登录
重启mysqld：systemctl restart mysqld
进入数据库：mysql
修改密码：use mysql;
		  update user set authentication_string = password('123456'), password_expired = 'N', password_last_changed = now() where user = 'root'; //修改密码为123456
重启数据库，之后就可以使用新密码登录了
# 创建readmine数据库
CREATE DATABASE redmine CHARACTER SET utf8;
CREATE USER 'redmine'@'localhost' IDENTIFIED BY 'redmine';
GRANT ALL PRIVILEGES ON redmine.* TO 'redmine'@'localhost';

# yum安装ruby
yum install ruby 
# 编译安装
wget https://cache.ruby-lang.org/pub/ruby/2.4/ruby-2.4.2.tar.gz
tar -zxvf ruby-2.4.2.tar.gz
cd ruby-2.4.2/
sudo ./configure 
sudo make
sudo make install

# 配置gem源
gem sources --add https://gems.ruby-china.com/ --remove https://rubygems.org/
gem sources -l

# 安装readmine
wget http://www.redmine.org/releases/redmine-3.4.3.tar.gz
tar -zxvf redmine-3.4.3.tar.gz
mv redmine-3.4.3 /var/redmine

# 准备数据库连接配置文件
cd /var/redmine/config/ 
cp database.yml.example database.yml

# 