Create_dir(){
[ ! -d ${Backup_Dir}/$IP ] && mkdir -p ${Backup_Dir}/$IP
echo "$Passwd" >${Passwd_Dir} && chmod 600 ${Passwd_Dir}
}
Backup_File(){
cd / && \
tar zcvp $Path/$IP/conf_$(date +%F).tar.gz var/spool/cron/root etc/rc.local etc/sysconfig/
iptables server/scripts &&\
# tar zcvp $Path/$IP/logs_$(date +%F).tar.gz app/logs/ &&\
tar zcvp - app/logs/|split -b 50000K - $Path/$IP/logs_$(date +%F).tar.gz. &&\
tar zcvp - /var/html/www/|split -b 50000K - $Path/$IP/www_$(date +%F).tar.gz. &&\
#tar zchf ${Backup_Dir}/$IP/sysconfig_$(date +%F).tar.gz var/spool/cron/root etc/rc.local server/scripts etc/sysconfig/iptables
}
Push_date(){
find ${Backup_Dir}/$IP/ -type f -name "*.tar.gz"|xargs md5sum >${Backup_Dir}/$IP/md5_$(date +%F).txt
rsync -az ${Backup_Dir}/$IP "rsync_backup"@${Server_IP}::backup --password-file=${Passwd_Dir}
if [ $? -eq 0 ];then
  action "backup" /bin/true
else
  action "backup" /bin/false
fi
find ${Backup_Dir}/$IP -type f -name "*.tar.gz" -mtime +7|xargs rm -f
if [ $? -eq 0 ];then
  action "rm" /bin/true
else
  action "rm" /bin/false
fi  
}
Create_dir
Backup_File
Push_date