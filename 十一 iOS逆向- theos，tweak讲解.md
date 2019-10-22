# 十一 iOS逆向- theos，tweak讲解

0.9972019.02.24 21:30:18字数 1039阅读 353

- theos，tweek简介
- theos安装配置
- 建立一个tweek项目
- theos Logos语法简介
- theos-tweak的实现过程

##### 一 theos,tweek简介

###### 1.1 theos简介

Theos是一套跨平台的开发工具套件，用于在不使用Xcode的情况下管理，开发和部署iOS软件。所就是iOS越狱开发工具包，类似与Xcode的功能，开发，打包，安装部署，这些功能它全都有。
Theos工具套件包含一些重要组件：

- 一个项目模板系统（[NIC](https://iphonedevwiki.net/index.php/NIC)），它为不同目的创建可立即构建的空项目，类似与Xcode创建一个iOS工程
- 由GNU Make驱动的强大的构建系统，能够直接创建.deb包，以便在Cydia中进行分发，类似与xcode打包发布
- [Logos](https://iphonedevwiki.net/index.php/Logos)，一种基于内置预处理器的指令库，旨在简化MobileSubstrate扩展开发，可以类比为越狱编程语言

###### 2.2 tweek简介

由Theos创建的一个tweek工程，最终编译后是一个插件，类似与一个iOS工程，执行具体的app hook的代码实现。

##### 二 theos安装配置

###### 1 安装签名工具ldid

- 先安装brew

```bash
$ /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

- 利用brew安装ldid

```ruby
$ brew install ldid
```

###### 2 修改环境变量

- 编辑用户的配置文件

```undefined
$ vim ~/.bash_profile
```

- 在.bash_profie添加环境变量.

```bash
export THEOS=~/theos
export PATH=$THEOS/bin:$PATH
```

- 让.bash_profiel配置的环境变量立即生效

```bash
$ source ~/.bash_profile
```

###### 3 下载theos

- 在$THEOS目录下载代码

```bash
$ git clone --recursive https://github.com/theos/theos.git $THEOS
```

##### 三 建立一个tweek项目

###### 1 通过 nic.pl创建

```csharp
xmldeMacBook-Pro:theostest xml$ nic.pl
NIC 2.0 - New Instance Creator
------------------------------
  [1.] iphone/activator_event
  [2.] iphone/application_modern
  [3.] iphone/application_swift
  [4.] iphone/cydget
  [5.] iphone/flipswitch_switch
  [6.] iphone/framework
  [7.] iphone/ios7_notification_center_widget
  [8.] iphone/library
  [9.] iphone/notification_center_widget
  [10.] iphone/preference_bundle_modern
  [11.] iphone/tool
  [12.] iphone/tool_swift
  [13.] iphone/tweak
  [14.] iphone/xpc_service
Choose a Template (required): 13
Project Name (required): theos_test
Package Name [com.yourcompany.theos_test]: com.xu.theos_test
Author/Maintainer Name [xml]: xml
[iphone/tweak] MobileSubstrate Bundle filter [com.apple.springboard]: com.apple.springboard
[iphone/tweak] List of applications to terminate upon installation (space-separated, '-' for none) [SpringBoard]:
Instantiating iphone/tweak in theos_test/...
Done.
```

tweek项目介绍

- Project Name 项目名称
- Package Name 项目ID
- Author/Maintainer Name 作者
- [iphone/tweak] MobileSubstrate Bundle filter 需要修改的app的Bundle Identifier
- [iphone/tweak] List of applications to terminate upon installation

###### 2 编辑Makefile

THEOS_DEVICE_IP :手机IP地址
THEOS_DEVICE_PORT：端口号

```ruby
export THEOS_DEVICE_IP=127.0.0.1
export THEOS_DEVICE_PORT=110110

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = theos_test
theos_test_FILES = Tweak.xm

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
    install.exec "killall -9 SpringBoard"
```

###### 3 编写代码，打开Tweak.xm文件

```objectivec
%hook ClassName

// Hooking a class method
+ (id)sharedInstance {
   return %orig;
}

// Hooking an instance method with an argument.
- (void)messageName:(int)argument {
   %log; // Write a message about this call, including its class, name and arguments, to the system log.

   %orig; // Call through to the original function with its original arguments.
   %orig(nil); // Call through to the original function with a custom argument.

   // If you use %orig(), you MUST supply all arguments (except for self and _cmd, the automatically generated ones.)
}

// Hooking an instance method with no arguments.
- (id)noArguments {
   %log;
   id awesome = %orig;
   [awesome doSomethingElse];

   return awesome;
}

// Always make sure you clean up after yourself; Not doing so could have grave consequences!
%end
```

###### 4编译

在tweek项目下执行make 命令

```go
xmldeMacBook-Pro:theos_test xml$ make
```

###### 5 打包

```go
xmldeMacBook-Pro:theos_test xml$ make package
```

###### 6 安装

```go
xmldeMacBook-Pro:theos_test xml$ make install
```

默认手机会重启SpringBoard。OK插件开发流程就这么几步。

###### 可能会遇到的问题



![img](https://upload-images.jianshu.io/upload_images/1972799-284ff247239b0d78.png?imageMogr2/auto-orient/strip|imageView2/2/w/580/format/webp)

解决办法：
检查文件路径有没有中文或者空格等特殊字符，修改成全英文的就好了

##### 四 theos Logos语法简介

Logos是[Theos](http://iphonedevwiki.net/index.php/Theos)开发套件的一个组件，它允许使用一组特殊的预处理器指令轻松清晰地编写代码

Wiki地址<http://iphonedevwiki.net/index.php/Logos>
我们介绍下它的一些常用的语法。
**%hook，%end ：** hook一个类的开始和结束
**%log** 打印方法调用详情
可以通过Xcode -> Window -> Devices and Simulators查看日志
**HBDebugLog：** 日志打印
**%new ：** 表示一个方法是新添加的
**%c(className)** 生成一个Class对象
**%orig ：** 保持函数原来的逻辑
**%ctor：** 加载动态库是调用它标示的方法
**%dtor：** 程序退出时调用
**logify.pl ：** 可以将一个头文件快速转换成已经打印信息的xml文件

```css
logify.pl xx.h > xx.xm
```

##### 五 theos-tweak的实现过程



![img](https://upload-images.jianshu.io/upload_images/1972799-202df5d7364facce.png?imageMogr2/auto-orient/strip|imageView2/2/w/706/format/webp)

theos-tweak的实现过程流程图

Tweak.xm hook代码编写好后，我们会执行make命令，之后就会生成一个动态库文件，然后当我们执行make package命令，那么theos工具就会将生成的动态库文件，以及一个plist描述文件打包成一个deb文件，类似于Xcode打包ipa文件。然后最后又执行make install命令，那么theos会根据Makefile配置的地址和端口号 进行SSH连接。然后将这个deb文件放到手机的/Library/MobileSubstrate/DynamicLibraries目录下。它会放两个文件，plist和动态库文件。
那么当我们打开hook的app时Cydia Substrate（越狱手机上已经默认安装了这个插件）会查看/Library/MobileSubstrate/DynamicLibraries目录下的plist文件看看当前的app有没有被hook,如果有就会去加载对应的动态库。那么app执行的时候遇到hook的方法就会去执行动态库里面的逻辑。
theos的tweak只是在app运行的时候去做拦截修改，实际app的物理代码没有做修改。