#!/bin/bash
#by kingle
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
. /etc/init.d/functions
nfs_ver='1.0'
. main/main.sh
. include/rsync_server_install.sh
. include/rsync_client_install.sh
. init.d/start_rsync.sh
. init.d/stop_rsync.sh
. include/rsync_backup.sh
. player/start_play.sh
clear
echo "+------------------------------------------------------------------------+"
echo "|            welocom to kingle linux the world                           |"
echo "+------------------------------------------------------------------------+"
echo "|                         Server setup nfs                               |"
echo "+------------------------------------------------------------------------+"
echo "|           For more information please visit kingle66.github.io         |"
echo "+------------------------------------------------------------------------+"
echo "|                        Please enter the number                         |"
echo "+------------------------------------------------------------------------+"
Install_Srync
Read_Sys
Read_Judge
case $num in
	1)
    Rsync_S_Install
	Rsync_S_Conf
	Rsync_S_User
	Rsync_S_File
		;;
	2)
    Rsync_C_Install
	Rsync_C_File
		;;
	3)
	Create_dir
	Backup_File
	Push_date
		;;
	5)
	Make_Jdds
		;;
	4)
	make_md5
		;;
	6)
	Test_Rsync
	echo "by kingle"
		;;
	7)
	Start_Rsync
		;;
	8)
	Stop_Rsync
		;;
	9)
	game
		;;
	0)
	exit 0
		;;
esac
