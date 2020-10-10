编译安装nginx
下载安装包
解压
进入解压目录
./configure 检测Linux系统安装该软件包所需要的依赖环境，依赖库文件检测系统是否有GCC编译器，同时产生makefile文件
这一步一般都会有报错。因为一台新机器的话不一定会有需要的安装包，所以，看到报错是正常的，一般都是因为缺少一些依赖文件之类的，下载就好
这里有几个需要下载的：
yum install pcre pcre-devel -y
yum install zlib zlib-devel -y

make 通过make工具读取Makefile文件，基于GCC编译器。将软件包中的源码文件编译生成二进制文件

make install  将第二步编译产生的二进制文件拷贝或安装到指定路径