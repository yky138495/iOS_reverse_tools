# 五 iOS逆向- 动态库共享缓存（dyld shared cache）

0.5162019.02.22 22:42:20字数 949阅读 314

- 共享缓存机制
- dyld简介
- 共享缓存库中抽取动态库

> 从iOS 3.1开始，为了提高系统的性能，所有的系统库文件都被打包保存到了一个很大的缓存文件当中，而为了减少冗余，原始的那些未打包的库二进制文件都被删掉了。

##### 一 共享缓存机制

在iOS系统中，每个程序依赖的动态库都需要通过dyld（位于/usr/lib/dyld）一个一个加载到内存，然而如果在每个程序运行的时候都重复的去加载一次，势必造成运行缓慢，为了优化启动速度和提高程序性能，共享缓存机制就应运而生。所有默认的动态链接库被合并成一个大的缓存文件，放到**/System/Library/Caches/com.apple.dyld/**目录下，按不同的架构保存分别保存着.



![img](https://upload-images.jianshu.io/upload_images/1972799-d5df427bdcdc9989.png?imageMogr2/auto-orient/strip|imageView2/2/w/569/format/webp)

没有动态库缓存的情况

如果没有缓存库存在的话，那么我们手机上的每一个App，如果要用到系统动态库的话，是需要每一个App都要去加载一次的，一样的资源被加载多次，无论是空间还是执行效率，都是造成了浪费





![img](https://upload-images.jianshu.io/upload_images/1972799-5006cc81fede27d4.png?imageMogr2/auto-orient/strip|imageView2/2/w/555/format/webp)

有了动态库缓存的情况

如果有缓存库存在的话，那么我们手机上的每一个App，如果要用到系统动态库的话，都去加载缓存库就好了，加载缓存库里的动态库会通过dyld这个动态连接器，dyld在加载动态库会做些优化。

##### 二 dyld简介

dynamic link editor，动态链接编辑器，或可叫做dynamic loader，动态加载器。是苹果操作系统一个重要组成部分，在系统内核做好程序准备工作之后，余下的工作交由dyld负责。它的源码是开源的。
**源码地址：**<http://opensource.apple.com/tarballs/dyld>

dyld加载过程
加载过程可细分为九步：
第一步：设置运行环境。
第二步：加载共享缓存。
第三步：实例化主程序。
第四步：加载插入的动态库。
第五步：链接主程序。
第六步：链接插入的动态库。
第七步：执行弱符号绑定
第八步：执行初始化方法。
第九步：查找入口点并返回。
仔细看一下第四步，我们[脱壳](https://www.jianshu.com/p/31f369f2dbc5)的时候就用到了它这一步功能.
具体每一步的详细解释可以参考这篇文章[dyld详解](https://www.dllhook.com/post/238.html#toc_6)

###### 2 dyld加载的[Mach-O](https://www.jianshu.com/p/44776f7eb2dd)文件类型

- MH_EXECUTE
- MH_DYLIB
- MH_BUNDLE

##### 三 共享缓存库中抽取动态库

因为iOS系统动态库，都放到一个大的缓存文件里面去了，我们想要分析了解系统的一些动态库具体的实现的时候，比如UIKit的实现，我们不可能把这整个文件丢到[hopper disassembler](https://www.jianshu.com/p/20077ceb2f75)里面去的，文件太大了hopper disassembler会很卡，很慢，有可能内存不足会崩掉。所以我们要把动态库从缓存文件中提取出来。
提取工具很多，我们只讲一个dsc_extractor提取

###### 步骤一 下载dyld源码



![img](https://upload-images.jianshu.io/upload_images/1972799-b959d41c09066183.png?imageMogr2/auto-orient/strip|imageView2/2/w/444/format/webp)

###### 步骤二 Xcode打开项目，定位到**dsc_extractor.cpp**文件



![img](https://upload-images.jianshu.io/upload_images/1972799-91d3279a3a898ce0.png?imageMogr2/auto-orient/strip|imageView2/2/w/1000/format/webp)

###### 步骤三 修改文件如下

```cpp
#include <stdio.h>
#include <stddef.h>
#include <dlfcn.h>

typedef int (*extractor_proc)(const char* shared_cache_file_path, const char* extraction_root_path,
                              void (^progress)(unsigned current, unsigned total));

int main(int argc, const char* argv[])
{
    if ( argc != 3 ) {
        fprintf(stderr, "usage: dsc_extractor <path-to-cache-file> <path-to-device-dir>\n");
        return 1;
    }

    //void* handle = dlopen("/Volumes/my/src/dyld/build/Debug/dsc_extractor.bundle", RTLD_LAZY);
    void* handle = dlopen("/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/usr/lib/dsc_extractor.bundle", RTLD_LAZY);
    if ( handle == NULL ) {
        fprintf(stderr, "dsc_extractor.bundle could not be loaded\n");
        return 1;
    }

    extractor_proc proc = (extractor_proc)dlsym(handle, "dyld_shared_cache_extract_dylibs_progress");
    if ( proc == NULL ) {
        fprintf(stderr, "dsc_extractor.bundle did not have dyld_shared_cache_extract_dylibs_progress symbol\n");
        return 1;
    }

    int result = (*proc)(argv[1], argv[2], ^(unsigned c, unsigned total) { printf("%d/%d\n", c, total); } );
    fprintf(stderr, "dyld_shared_cache_extract_dylibs_progress() => %d\n", result);
    return 0;
}
```

##### 步骤四 编译dsc_extractor.cpp文件

```ruby
xmldeMacBook-Pro:src xml$ cd /Users/xml/Documents/iOS学习/dyld-635.2/launch-cache
xmldeMacBook-Pro:launch-cache xml$ clang++ -o dsc_extractor dsc_extractor.cpp
```

生成可执行文件



![img](https://upload-images.jianshu.io/upload_images/1972799-35835a87465c87ce.png?imageMogr2/auto-orient/strip|imageView2/2/w/622/format/webp)

##### 步骤五 拷贝手机里的动态共享库文件到Mac,并把它放在dsc_extractor可执行文件的同一个目录下。



![img](https://upload-images.jianshu.io/upload_images/1972799-d3962c0b82de928d.png?imageMogr2/auto-orient/strip|imageView2/2/w/1011/format/webp)

###### 步骤六 开始抽取

执行命令: ./dsc_extractor 动态库共享缓存文件的路径 用于存放抽取结果的文件夹

```undefined
./dsc_extractor  dyld_shared_cache_arm64 arm64
```



![img](https://upload-images.jianshu.io/upload_images/1972799-7a5d2dca24982fbd.png?imageMogr2/auto-orient/strip|imageView2/2/w/998/format/webp)

抽取成功

抽取完成后，我们看到有好多文件，看到我定位的UIKit库了么，这里面就是UIkit的具体实现代码，想研究它的功能，直接把里面的二进制文件拖到hopper，慢慢研究探索吧。