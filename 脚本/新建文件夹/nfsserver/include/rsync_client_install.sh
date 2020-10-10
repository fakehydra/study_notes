Rsync_C_Install(){
    rpm -qa rsync|grep rsync &>/dev/null
    if [[ $? -eq 0 ]]; then
        echo "rsync Is already installed "
    else
        yum install rsync -y
        rpm -qa rsync|grep rsync &>/dev/null
        echo "rsync installing successing  "
    fi
}
Rsync_C_File(){
echo "${Passwd}" > ${PassWD_Dir}
chmod 600 ${PassWD_Dir}
mkdir ${} -p
}