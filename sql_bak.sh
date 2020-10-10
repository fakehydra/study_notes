#!/bin/bash
# script for backup mysql from 192.168.9.11
# auth lgao@hisw.cn
ip=11
pwd=
path=/sqlbak/sql_11/
date=`date +%F`
# 备份所有数据库
mysqldump -h 192.168.9.$ip -uroot -p$pwd -A -R >$path/sql_11_$date.sql


# 压缩备份数据库
tar zcf $pathsql_bak_$date.tar.gz $path/sql_11_$date.sql

# 删除原文件
rm -f $path/sql_11_$date.sql

# 添加md5校验
md5sum $pathsql_bak_$date.tar.gz >flag_$date.txt

# 保留30天
find $path -mtime +30 -exec rm -rf {} \;

# 校验md5
# md5sum -c flag_$date.txt |awk '{print $NF}' >




mysqldump -h 192.168.9.$ip -uroot -p$pwd -A -R --triggers --single-transaction>$path/sql_89_$date.sql