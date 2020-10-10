Start_Rsync(){
if [ ${Rsync_SS} -ne 2 ];then
        rm -rf /var/run/rsync.pid
        kill ${Rsync_Id}
        rsync --daemon
        [ -f /var/run/rsync.pid ] && action run /bin/true
else
        echo "run ok"
fi
}