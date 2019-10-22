开始安装：
1.iPhone安装Reveal Loader（软件源：http://apt.so/codermjlee）
2.安装Reveal 然后 -->Help --> Show Reveal Library in Finder --> iOS Library --> 找到RevealServer可执行文件
3.打开终端，通过ssh命令将RevealServer文件拷贝至iPhone终端的/Library/RHRevealLoader/目录下。(ps:可以使用USB链接iPhone，然后通过iFunBox查看iPhone该目录下是否存在该文件夹及文件夹下的RevealServer文件)

scp+文件路径+root@手机ip:/Library/RHRevealLoader/RevealServer
/**需要在同一wifi下**/
4.重启手机，在设置中找到Reveal，将需要进行UI调试的程序的开关开启。
5.打开Reveal，手机打开运行Reveal允许调试的软件。就可以在Reveal上查看UI了。
6.补充：如果Reveal未能发现运行的程序，将iPhone的/Library/RHRevealLoader/下的RevealServer改名为libReveal.dylib```。再次重启手机，进行查看，一般情况下是可以正常查看了哈~

