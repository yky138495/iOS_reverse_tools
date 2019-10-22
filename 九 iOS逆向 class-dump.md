# 九 iOS逆向 class-dump

0.272019.02.20 23:34:08字数 648阅读 234



![img](https://upload-images.jianshu.io/upload_images/1972799-90cc86c16373e9bc.png?imageMogr2/auto-orient/strip|imageView2/2/w/775/format/webp)

- class-dump简单介绍
- 如何使用class-dump

##### 一 class-dump简单介绍

> class-dump是可以把Objective-C运行时的声明的信息导出来的工具。实质就是可以导出.h文件。用class-dump可以把未经加密的app的头文件导出来

官方网站：<http://stevenygard.com/projects/class-dump/>
class-dump是一个mac端的命令行工具，用来导出Mach-O头文件的。

###### 1 首先我们要下载



![img](https://upload-images.jianshu.io/upload_images/1972799-b9b1f2a209899b62.png?imageMogr2/auto-orient/strip|imageView2/2/w/609/format/webp)

###### 2 下载后双击打开我们可以看到它是一个命令行工具



![img](https://upload-images.jianshu.io/upload_images/1972799-fbcbc6249271cea9.png?imageMogr2/auto-orient/strip|imageView2/2/w/590/format/webp)

###### 3 将执行文件class-dump复制到/usr/local/bin 目录



![img](https://upload-images.jianshu.io/upload_images/1972799-fa686b8d400eeb00.png?imageMogr2/auto-orient/strip|imageView2/2/w/820/format/webp)

###### 4 打开终端验证是否安装好了

```ruby
xmldeMacBook-Pro:~ xml$ class-dump
class-dump 3.5 (64 bit)
Usage: class-dump [options] <mach-o-file>

  where options are:
        -a             show instance variable offsets
        -A             show implementation addresses
        --arch <arch>  choose a specific architecture from a universal binary (ppc, ppc64, i386, x86_64, armv6, armv7, armv7s, arm64)
        -C <regex>     only display classes matching regular expression
        -f <str>       find string in method name
        -H             generate header files in current directory, or directory specified with -o
        -I             sort classes, categories, and protocols by inheritance (overrides -s)
        -o <dir>       output directory used for -H
        -r             recursively expand frameworks and fixed VM shared libraries
        -s             sort classes and categories by name
        -S             sort methods by name
        -t             suppress header in output, for testing
        --list-arches  list the arches in the file, then exit
        --sdk-ios      specify iOS SDK version (will look in /Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS<version>.sdk
        --sdk-mac      specify Mac OS X version (will look in /Developer/SDKs/MacOSX<version>.sdk
        --sdk-root     specify the full SDK root path (or use --sdk-ios/--sdk-mac for a shortcut)
xmldeMacBook-Pro:~ xml$
```

输出上面的信息，就代表安装好了，为啥要放到/usr/local/bin ，这个就不用说了吧，Mac默认环境变量配置有这个目录，你在在终端敲击任何命令，它都会去从这个目录中去找。好了，安装就是这么简单，下面看看怎么用。

##### 二 如何使用class-dump

class-dump 用来导出Mach-O头文件的，Mach-O文件有哪些种类，class-dump什么能导出Mach-O里面的头文件，我会专门介绍下Mach-O，文末我会简单提一下，现在我们导出头文件，主要是导出app里面二进制可执行文件的头文件。

###### 1 拿到ipa里面的Mach-O文件

我们可以网上下载ipa文件，然后解压，拿出里面的二进制可执行文件，我们也可以从越狱手机里面导出已经装上的app的二进制可执行文件，我这里是从手机里导出来的



![img](https://upload-images.jianshu.io/upload_images/1972799-e160eb37b6229f12.png?imageMogr2/auto-orient/strip|imageView2/2/w/947/format/webp)

我拖了一个计算器的二进制文件

###### 2 进入到了执行文件目录

Mac终端进入到Calculator所在目录

```bash
xmldeMacBook-Pro:~ xml$ cd /Users/xml/Documents/iOS学习/
```

###### 3 开始导出头文件

```cpp
xmldeMacBook-Pro:iOS学习 xml$ class-dump -H Calculator -o CalculatorHeader
2019-02-17 21:25:11.771 class-dump[6911:783784] Error: Cannot find offset for address 0x9000000001000626 in stringAtAddress:
```

我开始遇到了这个错误，最后通过换了这个[class-dump](https://github.com/lerpo/class-dump)文件，才解决这个问题。最后执行如下

```ruby
xmldeMacBook-Pro:iOS学习 xml$ class-dump -H Calculator -o CalculatorHeader
2019-02-17 21:25:47.949 class-dump[6916:784064] Warning: Parsing instance variable type failed, window
2019-02-17 21:25:47.949 class-dump[6916:784064] Warning: Parsing instance variable type failed, controller
2019-02-17 21:25:47.951 class-dump[6916:784064] Warning: Parsing instance variable type failed, displayController
2019-02-17 21:25:47.952 class-dump[6916:784064] Warning: Parsing instance variable type failed, keypadController
2019-02-17 21:25:47.952 class-dump[6916:784064] Warning: Parsing instance variable type failed, model
2019-02-17 21:25:47.952 class-dump[6916:784064] Warning: Parsing instance variable type failed, soundsPreferencesDomain
2019-02-17 21:25:47.952 class-dump[6916:784064] Warning: Parsing instance variable type failed, soundsEnabled
2019-02-17 21:25:47.952 class-dump[6916:784064] Warning: Parsing instance variable type failed, isSizeTransitioning
2019-02-17 21:25:47.952 class-dump[6916:784064] Warning: Parsing instance variable type failed, keypadTapGestureRecognizer
2019-02-17 21:25:47.953 class-dump[6916:784064] Warning: Parsing instance variable type failed, darwinObserver
2019-02-17 21:25:47.953 class-dump[6916:784064] Warning: Parsing instance variable type failed, maxLandscapeDigits
2019-02-17 21:25:47.954 class-dump[6916:784064] Warning: Parsing instance variable type failed, value
2019-02-17 21:25:47.954 class-dump[6916:784064] Warning: Parsing instance variable type failed, userEntered
2019-02-17 21:25:47.955 class-dump[6916:784064] Warning: Parsing instance variable type failed, delegate
2019-02-17 21:25:47.956 class-dump[6916:784064] Warning: Parsing instance variable type failed, maximumDigitCount
2019-02-17 21:25:47.956 class-dump[6916:784064] Warning: Parsing instance variable type failed, isAllClearActive
2019-02-17 21:25:47.956 class-dump[6916:784064] Warning: Parsing instance variable type failed, displayValue
2019-02-17 21:25:47.956 class-dump[6916:784064] Warning: Parsing instance variable type failed, memoryValue
```



![img](https://upload-images.jianshu.io/upload_images/1972799-859c4fb48c289299.png?imageMogr2/auto-orient/strip|imageView2/2/w/517/format/webp)

最后导出来的头文件

最后说一下class-dump是如何导出头文件的，其实Mach-O文件都有固定格式的，它里面含有符号表文件，class-dump就是通过读取符号表文件，才导出了头文件。

class-dump这个工具使用很简单，逆向中也常用到，还有我找的这个Caculator这个文件是没有加壳的，所以能导出头文件来，如果加了壳的应用是导不出来了，需要先砸壳。