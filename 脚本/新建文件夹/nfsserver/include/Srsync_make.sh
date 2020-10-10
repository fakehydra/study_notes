make_md5(){
#find /backup -type f -name "flag_$(date +%F)" |xargs md5sum -c  >/opt/mail_body_$(date+%F).txt
#mail -s "$(date +%U%T) back" kingle_753951@126.com </opt/mail_body_$(date +%F).txt
	
}