#!/bin/bash
read -p "please input a num: " num
expr $num "+" 1 &> /dev/null
if [ $? -eq 0 -a $num -ge 3 ];then
	echo "大于三"
else
	echo "no"
fi
