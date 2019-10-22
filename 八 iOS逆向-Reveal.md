# 八 iOS逆向-Reveal

0.272019.02.19 23:22:22字数 1097阅读 118



![img](https://upload-images.jianshu.io/upload_images/1972799-7f5fe648fdb0447d.png?imageMogr2/auto-orient/strip|imageView2/2/w/662/format/webp)

- Reveal简介
- Reveal环境配置
- Reveal使用实例

##### 一 Reveal简介

官网:[https://revealapp.com](https://revealapp.com/)
软件下载地址:[Reveal 17](https://github.com/lerpo/Revel.git)

> 下载至少reveal4版本，支持USB调试，speed fast

Reveal是能够在运行时调试和修改iOS应用程序。它能连接到应用程序，并允许开发者编辑各种用户界面参数，这反过来会立即反应在程序的UI上。

###### 1.1功能简介

1 新功能
可以查看手势识别器，支持检查视图的自定义子图层
2 调试功能
显示使用Scene Kit以全新的视角显示应用程序的视图层次结构。旋转，缩放和导航您的应用程序，在正在运行的应用程序中编辑和修改视图以立即查看效果。不再需要重新编译来测试简单的视觉变化，了解不熟悉的代码。Reveal可帮助您轻松识别哪些类实现哪些视图
3 布局指南（类似于Xcode上的Debug View Hierarchy）
直接在画布上查找和发现视图和约束之间的关系，在专用布局检查器中查看详细的布局属性，快速编辑或导航到影响视图布局的约束
4 聚焦(类似于Xcode上的Debug View Hierarchy）
通过折叠视图层次结构的各个部分，使复杂应用程序更易于理解，视图层次结构可能变得复杂。双击视图以关注它及其所有子视图，定制为手头任务显示的信息量。切换隐藏视图，约束，线框和内容的显示

> 逆向开发过程中，常用的就是这个工具，在分析别人app界面的时候非常方便，拿到一个app首先都是要通过这个工具去查找界面视图，然后分析视图层级结构，最后hook你要修改的功能。

##### 二 Reveal环境配置

###### 2.1步骤一

1 打开cydia添加软件源：[http://apt.so/8223785](http://apt.feng.com/8223785)
2 在Cydia栏搜索Reveal Loader,然后点击安装



![img](https://upload-images.jianshu.io/upload_images/1972799-1a93a88c410bc985.png?imageMogr2/auto-orient/strip|imageView2/2/w/294/format/webp)

Reveal Loader



###### 2.2步骤二





安装完Reveal Loader之后，找到手机设置，会有Reveal Loader这个item，点击进去，然后选择要调试的App ，为了省事，建议全都打开(插个题外话，为什么在设置里面会出现Reveal这一行，其实它也是逆向了系统设置这个App，然后hook设置的当前页面的tabview相关方法，添加了Reveal这个item，然后添加点击事件等，当我们熟悉了逆向，我们也可以给系统app添加各种功能)



![img](https://upload-images.jianshu.io/upload_images/1972799-c152fdc8645b0935.png?imageMogr2/auto-orient/strip|imageView2/2/w/778/format/webp)

Reveal Loader 真机配置

###### 2.3步骤三

1 找到Mac电脑上的的Reveal 中的RevealServer文件，覆盖iPhone的/Library/RHRevealLoader/RecealServer文件



![img](https://upload-images.jianshu.io/upload_images/1972799-dfa566c154c3676f.png?imageMogr2/auto-orient/strip|imageView2/2/w/483/format/webp)

打开Mac上安装好的Reveal 在help一栏点击



![img](https://upload-images.jianshu.io/upload_images/1972799-59054bcd21aa1537.png?imageMogr2/auto-orient/strip|imageView2/2/w/426/format/webp)

替换手机上的文件，通过ifunbox找到手机相应目录，直接把mac上的文件直接拖过去就行了

2 在手机上输入命令重启SpringBoard:

```
root$: killall SpringBoard
```

或者重启手机：

```
root$: reboot
```

如果手机是不完美越狱，建议只重启SpringBoard就行了。



###### 2.4步骤四





1 打开Mac上的Reveal，连接手机，然后选择一个应用打开，你就可以看到下面的界面了



![img](https://upload-images.jianshu.io/upload_images/1972799-b82379b5ac6ad7b2.png?imageMogr2/auto-orient/strip|imageView2/2/w/540/format/webp)

reveal调试

2 选择USB调试（如果选这Wifi连接，要保证手机和电脑要在同一个局域网内，此外wifi连接没有usb速度快，稳定）



![img](https://upload-images.jianshu.io/upload_images/1972799-a3a0bbe4995a5cc6.png?imageMogr2/auto-orient/strip|imageView2/2/w/810/format/webp)

展示当前app页面

到此reveal环境就配置完成了。

##### 三 Reveal使用实例



![img](https://upload-images.jianshu.io/upload_images/1972799-d337df508c8ed6dc.png?imageMogr2/auto-orient/strip|imageView2/2/w/1075/format/webp)

Reveal 界面结构

###### 3.1界面主要分为三部分：

1. 左边部分是整个界面的层级关系，在这里以树形层级的方式来查看全部界面元素。
2. 中间部分是一个可视化的查看区域，用户可以在这里切换2D盒3D的查看方式，这里看到的也是程序实运行的实时界面。
3. 右边部分是控件的详细参数查看区域，当我们选中某一个具体控件时，右边就可以显示该控件的具体的参数列表。我们除了可以查看这些参数列表是否正确外，还可以尝试修改这些值。所有的修改都可以实时翻反应到中间的预览区域内。

###### 3.2 逆向开发中的使用

如果我们拿到一个App，最直观的认识就是先看看它的界面构成，所以在逆向中，我们首先就会先看看它的界面构成，然后在做进一步的深度分析，最简单的去广告的例子。
如下：
我们打开爱奇艺应用，进入到主页



![img](https://upload-images.jianshu.io/upload_images/1972799-ac91b16257834d2e.png?imageMogr2/auto-orient/strip|imageView2/2/w/1026/format/webp)

找到广告控件

看图我们发现主页有个广告，它是存在一个QYASTableview里面的item，然后接下来我们只要hook,QYASTableview里面的方法，删除调广告类型的数据源就可以了，具体是，现拿到爱奇艺二进制文件的头文件，然后找到QYASTableview，然后查看里面的方法，利用theos tweek,hook代码，这里我们主要将reveal,具体流程就不细讲了，在讲解theos时会详细说明。