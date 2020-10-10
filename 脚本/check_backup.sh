#true rsync service is start ok
killall rsync
if [ $? -eq 0 ]  
then
rsync --daemon
else
echo "rsync seryer is not start,i will start now" && rsync --daemon
fi


#save
day=`date +%w`
if [ $day -eq 1 ]
then
tar zcfP /backup/date_$(date +%F_%w).tar.gz /backup/* && cp /backup/date_$(date +%F_%w).tar.gz /tmp/
else
echo "sorry,today is not MON"
fi
#check 
find /backup -type f -name "flag_$(date +%F)" |xargs md5sum -c  >/opt/mail_body_$(date +%F).txt
#send mail
mail -s "$(date +%F_%T) back" 664341340@qq.com  </opt/mail_body_$(date +%F).txt
if [ $? -eq 0 ]
then
echo "mail is send ok"
else
echo "mail send error!!!you need send again"
fi
