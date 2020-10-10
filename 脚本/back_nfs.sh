#!/bin/bash
##############################################################
# File Name: back_nfs.sh
# Version: V1.0
# Author: oldboy
# Organization: www.oldboyedu.com
##############################################################
# 1.检测本地环境是否存在备份目录，如果不存在则自动创建，如果存在则自动跳过
ipinfo=$(hostname -i)
dateinfo=$(date +%F_week%w -d -1day)
back="/backup" 
if [ -d $back ];then
    echo "$back 已经存在"
else
    echo "创建$back 中。。。"
    mkdir -p $back
    if [ $? -eq 0 ];then
        echo "创建$back 成功"
    else
        echo "创建$back 失败"
        exit 88
    fi
fi
# 2.压缩数据到本地备份目录
mkdir $back/$ipinfo -p
cd / && tar zchf $back/$ipinfo/$dateinfo-bak.tar.gz ./var/spool/cron/root ./etc/rc.local ./server/scripts ./etc/sysconfig/iptables
#03. 生成指纹文件信息                                                                      
find $back/$ipinfo/ -type f -name "*$dateinfo-bak.tar.gz"|xargs md5sum >>$back/$ipinfo/finger.txt
#04. 推送备份目录数据到rsync服务器
rsync -az $back/ rsync_backup@172.16.1.41::backup --password-file=/etc/rsync.password
#05. 删除7天以前的备份数据
find $back/ -type f -name "*.tar.gz" -mtime +7|xargs rm -f

