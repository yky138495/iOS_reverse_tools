# 十 iOS逆向- hopper disassembler

0.272019.02.20 23:25:50字数 493阅读 616



![img](https://upload-images.jianshu.io/upload_images/1972799-255433208c1a68a0.png?imageMogr2/auto-orient/strip|imageView2/2/w/1030/format/webp)

- hopper介绍，下载安装
- hopper的简单使用

##### 一 hopper介绍，下载安装

> Hopper是一个可以帮助我们静态分析可执行文件的工具。但对于我们iOS逆向这块来说它能够将Mach-O文件的机器语言代码反编译成汇编代码、OC伪代码或者Swift伪代码。

官网地址：[https://www.hopperapp.com](https://www.hopperapp.com/)
软件下载:[ Hopper Disassembler_4.0.8](https://github.com/lerpo/Revel/blob/master/Hopper%20Disassembler_4.0.8_xclient.info.dmg)

###### 1.1 安装步骤

1 下载Hopper Disassembler.dmg，点击安装，这个就不多讲了，跟其他软件安装没差别，安装完成后，点击图标，打开工具



![img](https://upload-images.jianshu.io/upload_images/1972799-db0627a1f40a2e2f.png?imageMogr2/auto-orient/strip|imageView2/2/w/59/format/webp)

2 打开后页面，因为是破解版的，点击try The Demo就好了。



![img](https://upload-images.jianshu.io/upload_images/1972799-1afe829edd08b2d0.png?imageMogr2/auto-orient/strip|imageView2/2/w/1151/format/webp)

image.png

3 简单说明一下面板各个区域的功能



![img](https://upload-images.jianshu.io/upload_images/1972799-871e5f22a2bfc5ae.png?imageMogr2/auto-orient/strip|imageView2/2/w/1200/format/webp)

面板简介图

要想知道每一个面板区域的详细功能介绍，请看官方教程

https://www.hopperapp.com/tutorial.html

一般强大的东西看起来都很简洁，简单。基本功能就说这么多，余下的自己慢慢研究吧，接下来讲一讲怎么用。



##### 二 hopper的简单使用

我们文初说了我们用它主要就是将Mach-O文件的机器语言代码反编译成汇编代码、OC伪代码。那我们解析来要分三步走。

###### 步骤一 先搞个Mach-O文件

主要就是反编译Mach-O，首先我们要找一个这样的文件，我网上下载了一个微信的IPA <http://www.51ipa.com/network/chat/WeiXin-iPhone.html>。



![img](https://upload-images.jianshu.io/upload_images/1972799-61b42c2cc2ec12a1.png?imageMogr2/auto-orient/strip|imageView2/2/w/722/format/webp)

微信IPA

下载下来后，解压，找到weixin.app，然后查看包内容，找到图中二进制可执行文件



![img](https://upload-images.jianshu.io/upload_images/1972799-28a2319f22331bad.png?imageMogr2/auto-orient/strip|imageView2/2/w/992/format/webp)

image.png



###### 步骤二 将Mach-O文件拖到Hopper Disassembler





![img](https://upload-images.jianshu.io/upload_images/1972799-5b4c69cfe571e506.png?imageMogr2/auto-orient/strip|imageView2/2/w/1189/format/webp)

Mach-O拖到Hopper Disassembler

我们看到微信可执行文件是个胖二进制文件，支持ARM v7,

AArch 64

两种架构



###### 步骤三 开始分析

我们选择一个架构开始分析，这里我选择
ARM V7



![img](https://upload-images.jianshu.io/upload_images/1972799-831f06131f9c6d61.png?imageMogr2/auto-orient/strip|imageView2/2/w/1196/format/webp)

开始加载



![img](https://upload-images.jianshu.io/upload_images/1972799-2aa0a65988bded3d.png?imageMogr2/auto-orient/strip|imageView2/2/w/1200/format/webp)

加载完成

简单操作步骤就这三步，接下来最难的就是如何去分析了，要有目标
1 你要分析要了解那一块内容
2 有什么线索能定位到分析区域，(class_dump,分析头文件，找到大致方法啊等等)
3 大胆猜测逐步验证。
我觉得简单的可以先顺着这个思路搞。

最后通过他这个分析输出，其实就是找到Mach-O文件描述信息，然后分步解析，就像我们读取XML格式文件一样，Mach-O也是有固定格式的，Hopper Disassembler就类似于SAX这种XML解析器。



![img](https://upload-images.jianshu.io/upload_images/1972799-de582a9a79ef4ef8.png?imageMogr2/auto-orient/strip|imageView2/2/w/1198/format/webp)



1人点赞

iOS逆向工程