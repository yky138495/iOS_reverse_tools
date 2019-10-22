# 一 iOS 逆向工程概述

22019.02.14 15:37:34字数 769阅读 445

- 1 什么是iOS逆向工程
- 2 iOS逆向的目的
- 3 iOS逆向过程以及方法

##### 一 什么是iOS逆向工程

iOS逆向工程指的是在软件层面上进行逆向分析的过程，用大白话来讲就是推导应用的代码实现和逻辑。就是给你一个IPA包，你能推导出他的代码实现，和逻辑实现，因为我们拿不到别人的源代码，但是我们又想知道它是怎么编码实现的，所以才有了逆向这么个玩意，iOS逆向过程简单的图示：



![img](https://upload-images.jianshu.io/upload_images/1972799-b0b47c72a78371ef.png?imageMogr2/auto-orient/strip|imageView2/2/w/690/format/webp)

逆向过程

> 就等于拿到手机上的应用程序，分析它的可执行文件，通过工具转成汇编，以至于转换成更高级的语言object c /swift等的一个过程

##### 二 iOS逆向的目的

###### 1 学习优秀App的设计

当你看到一个App有一些非常好用的功能，你想学习或者你也需要实现相同的功能，这样你就可以逆向它的实现，去分析它的实现过程

###### 2 更好的去加强自己开发App的安全

当你熟悉了iOS逆向工程，今后在开发自己App的时候，哪些地方更容易别被人攻破，从而有效的去避免

###### 3 学习iOS系统未开源库的一些实现。

比如我们常用的UIKit的实现等等

###### 4 视野更远了，iOS开发就会不在局限于画界面，数据，网络这些操作了

iOS逆向你能够了解到整个iOS系统的大致底层，内核，程序加载过程呀，App编译过程呀，等等

###### 5 可以改变现有app的一些功能

去爱奇艺App的广告，微信抢红包等等。（当然这个学习可以，不可以作为商业利益，违法的）

###### 三 iOS逆向过程以及方法

不废话，先看图：



![img](https://upload-images.jianshu.io/upload_images/1972799-13087bb7cc309a80.png?imageMogr2/auto-orient/strip|imageView2/2/w/778/format/webp)

逆向过程及方法

> ###### 逆向app思路
>
> 1 界面分析（Cycript ,Reveal）
> 2 代码分析
> 对Mach-o文件的静态分析
> MachOView ,class-dump, Hopper Disassembler,ida等
> 3 动态调试
> 对运行中的app进行代码调试
> debugserver, LLDB
> 4 代码编写
> 注入代码到app中
> 必要时还可能需要重新签名，打包ipa

从上到下整个一个流程，每个步骤都有相应的开发工具，循序渐进，把每一步都学好了，整个逆向你也就熟悉的差不多了。

系列文章
[一 iOS 逆向工程概述](https://www.jianshu.com/p/209bd8a771c3)
[二 iOS逆向-逆向环境搭建](https://www.jianshu.com/p/df9be327a701)
[三 远程登录(OpenSSH)/USB登录到手机](https://www.jianshu.com/p/4b85419d92b5)
[四 iOS逆向- Mach-O](https://www.jianshu.com/p/44776f7eb2dd)
[五 iOS逆向- 动态库共享缓存（dyld shared cache）](https://www.jianshu.com/p/d225df2f1690)
[六 iOS逆向 - 脱壳](https://www.jianshu.com/p/31f369f2dbc5)
[七 iOS逆向 - Cycript](https://www.jianshu.com/p/143c79121c9e)
[八 iOS逆向-Reveal](https://www.jianshu.com/p/2cf4e3392365)
[九 iOS逆向 class-dump](https://www.jianshu.com/p/df20e4357bed)
[十 iOS逆向- hopper disassembler](https://www.jianshu.com/p/20077ceb2f75)
[十一 iOS逆向- theos，tweak讲解](https://www.jianshu.com/p/4343f1703616)
[十二 iOS逆向-动态调试](https://www.jianshu.com/p/105761cc45aa)
～～～～不断更新中。。。。。