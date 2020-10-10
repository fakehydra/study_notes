#/bin/bash
host=$1
item=$2
value=$3
echo '{"request" :"sender data","data":[{"host":'\"$host\"',"key":'\"$item\"',"value":'\"$value\"'}]}'|nc 192.168.56.30 10051 && echo ""
