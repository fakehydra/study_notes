Make_Jdds(){
	touch /server/script/1.txt
	[ -f /server/script/1.txt ] && mkdir -p /server/script/
	mv jb2.sh /server/script/backup.sh
	echo '####rasync beifen fuwu'
	echo '* * * * * /bin/sh /server/script/backup.sh &>/dev/null ' >>/var//var/spool/cron/${Rname}
}