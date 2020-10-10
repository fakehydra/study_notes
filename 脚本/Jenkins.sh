#!/bin/bash
#目标服务器IP地址
host=$1
#job名称
job_name=$2
#包名
name=web-$(date +%F)-$(($RANDOM+10000))
#打包
cd /var/lib/jenkins/workspace/${job_name} && tar czf /opt/${name}.tar.gz ./*
#发送包到目标服务器
ssh ${host} "cd /var/www/ && mkdir ${name}"
scp /opt/${name}.tar.gz $host:/var/www/${name}
#解包
ssh ${host} "cd /var/www/${name} && tar xf ${name}.tar.gz && rm -f ${name}.tar.gz"
#使用软链接方式部署服务
ssh ${host} "cd /var/www && rm -rf html && ln -s /var/www/${name} /var/www/html"