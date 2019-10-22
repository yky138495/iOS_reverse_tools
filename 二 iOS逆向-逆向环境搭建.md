# 二 iOS逆向-逆向环境搭建

0.9122019.02.19 23:06:38字数 1630阅读 347

- 开发设备准备
- iOS越狱介绍，以及越狱方法
- cydia简介
- 必备插件安装

##### 1.1 开发设备准备

###### 1 查看目前越狱所支持的系统版本以及设备:[越狱查看](http://jailbreak.25pp.com/ios)



![img](https://upload-images.jianshu.io/upload_images/1972799-b60badf5d6400d0e.png?imageMogr2/auto-orient/strip|imageView2/2/w/703/format/webp)

可以越狱的情况，有些更低版本显示的是完美越狱



![img](https://upload-images.jianshu.io/upload_images/1972799-274ba894da246d12.png?imageMogr2/auto-orient/strip|imageView2/2/w/898/format/webp)

不可以越狱的情况

###### 2 如果没有设备，建议网上二手市场购买，尽量要符合以下条件



![img](https://upload-images.jianshu.io/upload_images/1972799-4913bd790cdb4711.png?imageMogr2/auto-orient/strip|imageView2/2/w/456/format/webp)

购买条件



![img](https://upload-images.jianshu.io/upload_images/1972799-4d91a029b889ecda.png?imageMogr2/auto-orient/strip|imageView2/2/w/571/format/webp)

购买渠道

##### 1.2 iOS越狱介绍，以及越狱方法

###### 1 什么是iOS越狱（Jailbreak）

利用iOS系统漏洞，获取iOS系统的最高权限（Root）,解开之前的各种限制，比如：查看系统目录，这个在Android手机上是一个很常见的行为，但是iOS由于权限限制你就无法查看，一旦越狱了，就相当于获取到了权限了，所以也就能查看了。

###### 2 越狱的优缺点

###### 越狱的优点：

1.系统权限很高，可以自己优化系统，可以修改系统文件，可以安装更多拥有高系统权限的软件，实现更多高级功能!例如：与其他设备蓝牙发送文件、短信回执、来电归属地、文件管理、浏览器下载[插件](http://jailbreak.25pp.com/chajian/)、flash插件、内容管理等等。

2.可以安装破解后的软件。

3.可以更换主题、图标、短信铃声等等，打造个性的[手机](http://wap.25pp.com/)。

4.可以借助第三方文件管理软件灵活的管理系统或者其他文件，比如把iPhone当[移动](http://wap.25pp.com/android/detail_282701/)硬盘(u盘)。

###### 越狱的缺点：

1.费电，越狱后系统会常住一些进程保持越狱的状态。视系统级软件(deb格式)安装的数量，越狱后耗电速度约提升10% ~20%。

2.可能会造成系统不稳定，拥有很高系统权限的同时，也伴随着系统崩溃的危险，这个道理大家能理解吧?你可以修改它，但是你不能保证永远正确的修改它。所以系统级的软件宁缺毋滥，不了解用途的情况下不要乱安装。

3.在新的手机固件版本出来的时候，不能及时的进行更新。每个新版本的固件，都会修复上一个版本的越狱漏洞，使越狱失效。因此如果需要保持越狱后的功能，要等到新的越狱程序发布，才能[升级](http://www.25pp.com/news/list_135.html)相应的手机固件版本。

4.越狱过程中滋生小BUG，但是不是很影响使用.

###### 3 什么是完美越狱，不完美越狱

###### 完美越狱

手机可以重启，重启后cydia还在，而且没有导致别的问题，不过电池相对来说还是会消耗的稍微快一点，但是大多数人都不是很明显。

###### 不完美越狱

不能关机，关机重启后.越狱就失效了，而且越狱不完美的话会出现很多问题，例如白苹果，电池消耗过快.机器反应变卡.等等不确定的因素。

> 总之来说完美越狱稳定些，主要差别就是，不完美越狱不能关机，关机越狱就失效了，其他的差别到是不大，建议还是完美越狱好些，在逆向开发过程中少一点麻烦。

上面介绍了iOS越狱方面的一些基本概念，下面就来进行具体的手机越狱，现在的越狱工具很多，尽量选商业公司开发的工具，因为他们在不断的更新着，完善着。这里我用的是爱思助手。

###### 1.3 越狱方法

###### 步骤一 下载[爱思助手PC版](https://www.i4.cn/)



![img](https://upload-images.jianshu.io/upload_images/1972799-0d362e942f072503.png?imageMogr2/auto-orient/strip|imageView2/2/w/840/format/webp)

软件下载界面

> 注意：目前爱思助手PC版只有Windows版的，没有Mac版的，所以整个越狱过程我们要在windows平台上完成

###### 步骤二 傻瓜式安装，一键越狱



![img](https://upload-images.jianshu.io/upload_images/1972799-86c0e4b424149101.png?imageMogr2/auto-orient/strip|imageView2/2/w/967/format/webp)

点击一键越狱，选择你系统的版本

###### 步骤三



![img](https://upload-images.jianshu.io/upload_images/1972799-aec56f9e7998c756.png?imageMogr2/auto-orient/strip|imageView2/2/w/246/format/webp)

越狱成功之后就会有这两个文件

###### 如何判断是否越狱成功呢？

1 桌面是否有Cydia



![img](https://upload-images.jianshu.io/upload_images/1972799-d9c01820f2dc5e95.png?imageMogr2/auto-orient/strip|imageView2/2/w/311/format/webp)

越狱成功会有Cydia这个应用

2 其他第三方MAC工具（pp助手，爱思助手)



![img](https://upload-images.jianshu.io/upload_images/1972799-82e628f67b2c8726.png?imageMogr2/auto-orient/strip|imageView2/2/w/917/format/webp)

是否越狱选项显示的

3 代码判断是否越狱成功
新建一个iOS工程

```objectivec
#import "ViewController.h"
@interface ViewController ()

@end
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    if([[NSFileManager defaultManager] fileExistsAtPath:@"/Applications/Cydia.app"]) {
        NSLog(@"手机已越狱");
    }else {
        NSLog(@"手机未越狱");
    }

}
@end
```

上面讲了手机如何越狱，很简单的内容，一旦手机越狱，就会安装cydia这个应用，那么cydia这个应用是干什么的，我们需要详细了解一下。

##### 三 Cydia简介

Cydia本质就是类似于越狱后的*App Store*,你可以在Cydia中安装各种第三方的软件，包括，插件，补丁以及App。
Cydia的作者Jay Freeman(saurik)



![img](https://upload-images.jianshu.io/upload_images/1972799-dd7e5f9d775b51eb.png?imageMogr2/auto-orient/strip|imageView2/2/w/357/format/webp)

Cydia的作者Jay Freeman

Jay Freeman这位大神开发了好多插件，我们在学习iOS逆向，需要安装一些插件的时候，如果发现作者是他，一般这个插件都是比较好用的。



###### 1 如何使用Cydia安装软件？

在Cydia安装软件，根在appStore安装软件还是有一点点差别的，为什么呢，第一appStore是有苹果官方维护的，所以软件来源都是同一的，发布app过的也都知道，都是上传到itunes,但是Cydia是开源的，除了作者维护一些好用的插件，app，其他的开发者也可以开发插件，app，所以软件来源就很多了，那怎么装别的的插件，app呢，很简单，就是把别人的软件路径先填进来就可以了。所以使用Cydia安装软件的步骤是：

###### 步骤一 添加软件源



![img](https://upload-images.jianshu.io/upload_images/1972799-405f2ff99e379ede.png?imageMogr2/auto-orient/strip|imageView2/2/w/831/format/webp)

添加软件源

###### 步骤二 搜索安装插件或者app



![img](https://upload-images.jianshu.io/upload_images/1972799-19f3739dcf53e3cf.png?imageMogr2/auto-orient/strip|imageView2/2/w/839/format/webp)

搜索安装插件或者app

我们如图可以看见，有些软件不支持我们当前设备怎么办，第一我们可以刷新多试验几次，如果还不行的化，我们可以离线安装，文末我们讲解一下。

##### 三 必备插件安装



![img](https://upload-images.jianshu.io/upload_images/1972799-99d801b56a52e0ba.png?imageMogr2/auto-orient/strip|imageView2/2/w/851/format/webp)

需要安装的软件/插件

最后补充一下离线安装插件的方法

###### 离线安装

###### 步骤一 从网上下载deb格式的安装包



![img](https://upload-images.jianshu.io/upload_images/1972799-0c80a65de47a495a.png?imageMogr2/auto-orient/strip|imageView2/2/w/770/format/webp)

image.png

###### 步骤二 将deb安装包放到/var/root/Media/Cydia/AutoInstall



![img](https://upload-images.jianshu.io/upload_images/1972799-661f97b4c88db2a0.png?imageMogr2/auto-orient/strip|imageView2/2/w/801/format/webp)

拖到这里面就OK了

###### 步骤三 重启手机Cydia就会自动安装deb

注意如果不是完美越狱，要评估手机重启后会不会有问题，我的手机是不完美越狱，我重启了，越狱就失效了，但是我重新越狱，之前安装的软件都还在，这样其实也没什么大的影响。