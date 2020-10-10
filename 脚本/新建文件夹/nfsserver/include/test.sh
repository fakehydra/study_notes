Test_Rsync(){
	rsync -avz anaconda-ks.cfg rsync_backup@172.16.1.41::backup --password-file=${PassWD_Dir}
if [ $? -eq 0 ];then
	action rsync ok /bin/true
else
	echo "please to help!"
fi
}
