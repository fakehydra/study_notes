#!/bin/bash
##############################################################
# File Name: back.sh
# Version: V1.0
# Author: zhuchao
# Organization: www.oldboyedu.com
##############################################################
check="/tmp/check_info.txt"
back="/backup"
if [ -d $back ];then
    echo "$back 已创建"
else
    echo "创建$back 目录中"
    mkdir -p $back
    if [ $? -eq 0 ];then
        echo "创建成功"
    else
        echo "创建失败"
        exit 1
    fi
fi
# 01 进行数据完整性验证，并生成验证结果文件
find /backup -type f -name "finger.txt"|xargs md5sum -c &>$check
# 02 实现发送邮件功能
mail -s "检查结果信息" 18205172474@163.com<$check
# 03 保存180天前的数据信息
find /backup -type f -name "*.tar.gz" -not -name "*_week1.tar.gz"|xargs rm -f
