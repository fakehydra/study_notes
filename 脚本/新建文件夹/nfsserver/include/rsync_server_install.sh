Rsync_S_Install(){
if [ $(id -u) != "0" ]; then
    echo "Error: You must be root to run this script, please use root to install server rsync"
    exit 0
fi
    rpm -qa rsync|grep rsync &>/dev/null
    if [[ $? -eq 0 ]]; then
        echo "rsync Is already installed "
    else
        yum install rsync -y
        rpm -qa rsync|grep rsync &>/dev/null
        echo "rsync installing successing  "
    fi
}
Rsync_S_Conf(){
cat >/etc/rsyncd.conf<<EOF
        uid = rsync
        gid = rsync
        use chroot = no
        max connections = 200
        timeout = 300
        pid file = /var/run/rsyncd.pid
        lock file = /var/run/rsync.lock
        log file = /var/log/rsyncd.log
        ignore errors
        read only = no
        list = no
        hosts allow =10.0.0.0/24  
        auth users = rsync_backup
        secrets file =/etc/rsync.password
        [backup]
        path = $Backup_Dir
EOF
    if [ -f /etc/rsync.conf ];then
       action rsync configuration /bin/true
    else
       action rsync configuration /bin/false
       echo "please to help!!"
    fi
}
Rsync_S_User(){
id rsync &>/dec/null
if [ $? -ne 0 ];then
    useradd -s /sbin/nologin -M rsync
    action useradd /bin/true
else
    echo "hava user!!"
fi
}
Rsync_S_File(){
mkdir $ -p
chown -R rsync.rsync $
echo "$RootName:$Passwd" >/etc/rsync.password
chmod 600 /etc/rsync.password
}