Backup_Dir=/backup
PassWD_Dir=/etc/rsync.password
Passwd=kingle123
RootName=rsync_backup
IPduan=10.0.0.0/24
Rev=`tail -l /etc/rc.local`
IP=`hostname -I|awk '{print $2}'`
Server_IP=10.0.0.41
CPath=/backup/$IP
Rname=`hostname`
# Rsync_Id=`ps -ef|grep rsync|grep "rsync --daemon"|awk 'NR==1{print $2}'`
Rsync_SS=`ps -ef|grep rsync|grep "rsync --daemon"|wc -l`
Install_Srync(){
cat <<EOF
	1, 安装配置rsync服务端
	2, 安装配置rsync客户端
	3, 客户端备份文件程序启动
        4, 创建客户端定时备份上传脚本
        5, 创建服务端校验邮件定时任务
        6, 测试rsync是否成功
        7, 启动rsync
	8, 停止rsync
   	9，娱乐项目  
        0, 退出	
EOF
}
Read_Sys(){
read -p "请输入一个小于10的数值： " num	
}
Read_Judge(){
if [ $# -gt 1 ];then
	echo "start run "
else
	[ $# -ne 2 ] || echo "一个！！,别用了"  
	expr $num "+" 10 &>/dev/null
	if [ $? -eq 0 ];then
	action read /bin/true
	else
	action read /bin/false
	echo "请输入一个小于10数值！！"
	echo "看不懂中文就别玩了吧，bye！"		
fi
fi
}
