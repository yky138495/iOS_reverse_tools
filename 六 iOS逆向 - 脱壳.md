# 六 iOS逆向 - 脱壳

0.272019.02.21 23:50:59字数 1464阅读 531

- 加壳脱壳基本概念
- 使用dumpdecrypted工具进行iOSApp脱壳

##### 一 加壳脱壳基本概念

###### 一 什么是加壳？

就是利用特殊的算法，对可执行文件的编码进行改变（比如加密、混淆）以达到保护程序代码的目的。

###### 1 加壳的手段有哪些？

1 字符串加密
2 类名方法名混淆
3 程序代码混淆
4 加入安全SDK 等等...
总结这么多手段来说，就是把代码伪造成连它娘都不认识它，加壳其实并不影响你破解，只不过破解之后，你啥也看不明白，东西还是那个东西，只不过用各种算法是手段混淆了。



![img](https://upload-images.jianshu.io/upload_images/1972799-23e3ee404757dbe4.png?imageMogr2/auto-orient/strip|imageView2/2/w/607/format/webp)

iOS加壳执行流程图

凡是上传到appStore的App应用，苹果都已经做了加壳操作，一般逆向appStore下载的App都需要先进行脱壳

###### 1.2如何查看一个应用是否加壳？

###### 1 通过MachOView工具进行查看

用MachOView将一个app的可执行文件打开，看到如下界面，查看Mach-O文件的里面的**LC_ENCRYPTION_INFO_XX** 的**Crypt ID**等于零代表未加密的，如果等于其它值就代表已加密。



![img](https://upload-images.jianshu.io/upload_images/1972799-1234402f22dc3103.png?imageMogr2/auto-orient/strip|imageView2/2/w/893/format/webp)



###### 2 通过otool工具查看 otool -l

```ruby
xmldeMacBook-Pro:iOS学习 xml$ otool -l weixin | grep crypt
     cryptoff 16384
    cryptsize 1376256
      cryptid 1
xmldeMacBook-Pro:iOS学习 xml$ otool -l SpringBoard | grep crypt
xmldeMacBook-Pro:iOS学习 xml$ otool -l Calculator | grep crypt
```

如果是加壳的话他会打印出来信息，没加壳的话有可能会打印出信息，也有可能不会打印出信息

###### 二 什么是脱壳

就是还原程序到未加密混淆前的状态，对于iOS就是去掉壳程序，将未加密的可执行文件还原出来。

###### 1 脱壳的方式有哪些？

1 静态脱壳 （AppCrackr、Clutch、Crackulous）
就是在已经掌握和了解到了壳应用的加密算法和逻辑后在不运行壳应用程序的前提下将壳应用程序进行解密处理。



![img](https://upload-images.jianshu.io/upload_images/1972799-4bc4def8d7f1d3f9.png?imageMogr2/auto-orient/strip|imageView2/2/w/306/format/webp)

2 动态脱壳 （Dumpdecrypted）
就是从运行在进程内存空间中的可执行程序映像(image)入手，来将内存中的内容进行转储(dump)处理来实现脱壳处理。



![img](https://upload-images.jianshu.io/upload_images/1972799-d09b550457bda521.png?imageMogr2/auto-orient/strip|imageView2/2/w/486/format/webp)

###### 2 两种脱壳方式的优缺点

1 静态脱壳
优点：使用简单方便，直观
缺点：脱壳的方法难度大，而且加密方发现应用被破解后就可能会改用更加高级和复杂的加密技术
2 动态脱壳
优点：实现起来相对简单，且不必关心使用的是何种加密技术
缺点：上手使用麻烦些

接下来我们讲如何利用dumpdecrypted工具进行动态脱壳。
为什么不讲静态脱壳呢？有两个原因。
1 静态脱壳简单，小白也能上手。
2 静态脱壳有个弊端，就是别人一升级加密技术，它就不行了，我的手机是ios10.2,静态工具目前就搞不定，脱壳出错，所以只能用动态脱壳方式。

##### 二 使用dumpdecrypted工具进行iOSApp脱壳

我们先讲如何使用这个工具脱壳，然后再讲它的实现原理

> dumpdecrypted.dylib 是由德国安全专家stefanesser开发的一款砸壳工具

###### 2.1 脱壳步骤

###### 步骤一 下载dumpdecrypted工具<https://github.com/stefanesser/dumpdecrypted>





![img](https://upload-images.jianshu.io/upload_images/1972799-c79f21f25d25feb7.png?imageMogr2/auto-orient/strip|imageView2/2/w/550/format/webp)

下载下来有两个主要文件，

dumpdecrypted.c

是源代码文件 ，

Makefile

是编译脚本，可以将源代码编译成动态库，接下来我们编译动态库



###### 步骤二 编译dumpdecrypted.dylib

```ruby
xmldeMacBook-Pro:Downloads xml$ cd dumpdecrypted-master
xmldeMacBook-Pro:dumpdecrypted-master xml$ make
`xcrun --sdk iphoneos --find gcc` -Os  -Wimplicit -isysroot `xcrun --sdk iphoneos --show-sdk-path` -F`xcrun --sdk iphoneos --show-sdk-path`/System/Library/Frameworks -F`xcrun --sdk iphoneos --show-sdk-path`/System/Library/PrivateFrameworks -arch armv7 -arch armv7s -arch arm64 -c -o dumpdecrypted.o dumpdecrypted.c
`xcrun --sdk iphoneos --find gcc` -Os  -Wimplicit -isysroot `xcrun --sdk iphoneos --show-sdk-path` -F`xcrun --sdk iphoneos --show-sdk-path`/System/Library/Frameworks -F`xcrun --sdk iphoneos --show-sdk-path`/System/Library/PrivateFrameworks -arch armv7 -arch armv7s -arch arm64 -dynamiclib -o dumpdecrypted.dylib dumpdecrypted.o
ld: warning: directory not found for option '-F/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS12.1.sdk/System/Library/PrivateFrameworks'
ld: warning: directory not found for option '-F/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS12.1.sdk/System/Library/PrivateFrameworks'
ld: warning: directory not found for option '-F/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS12.1.sdk/System/Library/PrivateFrameworks'
```





![img](https://upload-images.jianshu.io/upload_images/1972799-d05b30ae05572327.png?imageMogr2/auto-orient/strip|imageView2/2/w/630/format/webp)

编译完成会生成

dumpdecrypted.dylib

这个动态库文件，接下来我们就是将这个动态库拷贝到手机上，进行动态脱壳。



###### 步骤三 将dumpdecrypted.dylib拷贝到手机/var/root目录



![img](https://upload-images.jianshu.io/upload_images/1972799-01e7a0b16c39ec10.png?imageMogr2/auto-orient/strip|imageView2/2/w/689/format/webp)

###### 步骤四 找到你要脱壳的应用开始脱壳

```csharp
applede-iPhone:~ root# ps -A
1540 ??         0:23.27 /var/containers/Bundle/Application/50D7ECBF-5F64-44A7-940F-22D884E16BE8/iQiYiPhoneVideo.app/iQiYiPhoneVideo
```

我找了一个爱奇艺的应用，我们把它的可执行文件拷贝到mac上使用otool工具查看它是否加壳了



![img](https://upload-images.jianshu.io/upload_images/1972799-652a049f3cbb59ff.png?imageMogr2/auto-orient/strip|imageView2/2/w/860/format/webp)

```ruby
xmldeMacBook-Pro:iOS学习 xml$ otool -l iQiYiPhoneVideo | grep crypt
     cryptoff 16384
    cryptsize 82853888
      cryptid 1
xmldeMacBook-Pro:iOS学习 xml$
```

cryptid 等于1，我们可以看到它是一个加了壳的二进制文件
那么下面我们开始砸壳，你要在手机/usr/root目录就是dylib所在的目录下执行命令，这里使用环境变量DYLD_INSERT_LIBRARIES将dylib注入到需要脱壳的可执行文件

```bash
applede-iPhone:~ root# DYLD_INSERT_LIBRARIES=dumpdecrypted.dylib /var/containers/Bundle/Application/50D7ECBF-5F64-44A7-940F-22D884E16BE8/iQiYiPhoneVideo.app/iQiYiPhoneVideo
```

执行完成后会在当前目录下生成脱壳后的文件



![img](https://upload-images.jianshu.io/upload_images/1972799-bbe1eea867264f72.png?imageMogr2/auto-orient/strip|imageView2/2/w/861/format/webp)

将它拖到Mac上使用otool查看是否已经脱壳

```ruby
xmldeMacBook-Pro:iOS学习 xml$ otool -l iQiYiPhoneVideo.decrypted | grep crypt
iQiYiPhoneVideo.decrypted:
    cryptoff 16384
   cryptsize 82853888
     cryptid 0
xmldeMacBook-Pro:iOS学习 xml$
```

cryptid 等于零0，已经脱壳了。OK就是这么简单几步。

如果执行DYLD_INSERT_LIBRARIES 的命令遇到如下错误错误



![img](https://upload-images.jianshu.io/upload_images/1972799-803db204545e7a40.png?imageMogr2/auto-orient/strip|imageView2/2/w/744/format/webp)

解决办法



![img](https://upload-images.jianshu.io/upload_images/1972799-71785e5be6e682b1.png?imageMogr2/auto-orient/strip|imageView2/2/w/1013/format/webp)

###### 2.2 实现原理

先来看一张被加壳后的应用程序被加载和运行的过程图：



![img](https://upload-images.jianshu.io/upload_images/1972799-de10fe41d0d5bb25.png?imageMogr2/auto-orient/strip|imageView2/2/w/562/format/webp)

加壳应用加载运行原理图

iOS/macOS 系统中，可执行文件、动态库等，都使用 DYLD(动态链接器) 加载执行。在 iOS 系统中使用 DYLD 载入 App 时，会先进行 DRM（数字加密技术） 检查，检查通过则从 App 的可执行文件中，选择适合当前设备架构的 Mach-O 镜像进行解密，然后载入内存执行，这个程序并没有解密的逻辑，当他被执行时，其实加载器已经完成了目标mach-o文件的装载工作，对应的解密工作也已经完成。
可以看到iOS动态链接库在加载iOS程序的时候，会先将可执行文件解密，然后将解密后的可执行文件装进内存，那我们的工具就简单了，就在他解密后插一脚，把它解密后的二进制文件拿出来，不就OK了。

有此可知dumpdecrypted本身并不做解密，它所做的工作只是将对应解密后的数据从内存中dump出来，复写到mach-o文件中，生成新的镜像文件，从而达到解密的效果。
具体实现步骤可以查看源码，网上也有很多的解析，在此我就不多赘述了。