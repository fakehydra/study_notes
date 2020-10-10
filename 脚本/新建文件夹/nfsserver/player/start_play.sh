game(){
cat <<EOF
 1, aclock
 2, clocksaver
 3, snake
 4, tetris
 5, translate
EOF
read -p "请输入一个小于10的数值： " num2
if [ $# -gt 1 ];then
	echo "start run "
else
	[ $# -ne 2 ] || echo "一个！！,别用了"  
	expr $num2 "+" 10 &>/dev/null
	if [ $? -eq 0 ];then
	action read /bin/true
	else
	action read /bin/false
	echo "请输入一个小于10数值！！"
	echo "看不懂中文就别玩了吧，bye！"		
fi
fi
case $num2 in
	1)
	. player/aclock.sh
		;;
	2)
	. player/clocksaver.sh
		;;
	3)
	. player/snake.sh
		;;
	4)
	. player/tetris.sh
		;;
	5)
	. player/translate.sh
		;;
	6)
	echo "end"
	exit 0
		;;
	*)
	echo "输入1-6的值"
		
esac

}
