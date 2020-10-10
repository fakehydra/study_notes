Stop_Rsync(){
    kill `ps -ef|grep rsync|grep "rsync --daemon"|awk 'NR==1{print $2}'`
    rm -rf /var/run/rsync.pid
    [ ${Rsync_SS} -ne 2 ] && echo "rsync stopping"
}