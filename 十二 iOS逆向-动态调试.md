# 十二 iOS逆向-动态调试

0.5642019.03.10 19:07:15字数 2414阅读 333

- 动态调试概念
- Xcode动态调试原理
- 调试任意第三方App
- LLDB简介

##### 一 动态调试概念

就是在程序运行的过程中，通过打断点，或者log输出等方式，查看函数调用流程，以及一些变量，参数，返回值等等这一系列流程. 在iOS开发中，直观上来讲我们经常利用Xcode来进行App的动态调试。



![img](https://upload-images.jianshu.io/upload_images/1972799-a5a92606d0af05ac.png?imageMogr2/auto-orient/strip|imageView2/2/w/891/format/webp)

Xcode调试界面

我们平时利用Xcode调试，只要点一下右面的箭头，运行程序，在我们想要断点的数字列表点一下，然后程序运行到这个地方的时候就会自行断点了，用起来非常方便，但是Xcode这个动态调试是怎么实现的呢，让我们一起来深入了解一下。

##### 二 Xcode动态调试原理

要想了解Xcode动态调试原理，我们需要了解两个东西 LLDB，debugserver。Xcode就是利用这两个工具进行动态调试的。

###### 2.1 什么是LLDB，debugserver

1 [LLDB](http://lldb.llvm.org/)是Mac OS X上Xcode的默认调试器，支持在桌面和iOS设备和模拟器上调试C，Objective-C和C ++
2 debugserver是运行在iOS上作为服务端，接收和执行LLDB传过来的命令，再把执行结果反馈给LLDB,显示给用户。

###### 2.2 Xcode动态调试流程



![img](https://upload-images.jianshu.io/upload_images/1972799-4ddfceda31e84f7a.png?imageMogr2/auto-orient/strip|imageView2/2/w/658/format/webp)

Xcode动态调试流程图

Xcode通过LLDB调试器把调试指令发送到手机上的debugserver,debugserver将命令转给相应的app,app将反馈信息给debugserver , 最后debugserver将命令执行结果返回给lldb，然后Xcode在界面进行结果展示。

###### 2.3 debugserver细节的一些讲解

###### 1 debugserver是手机内置的么？

debugserver一开始是不在iPhone手机上的，当我们Xcode第一次连接手机时，Xcode会自动将debugserver安装到手机上，所以当Xcode连接手机时，会很慢，其实它要做很多初始化配置工作的。

###### 2 debugserver存在哪个目录？

一开始是存在Mac的Xcode里面的**/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/De viceSupport/9.0/DeveloperDiskImage.dmg/usr/bin/debugserver**的，安装到手机上后会放到手机的**/Developer/usr/bin/debugserver**目录下。



![img](https://upload-images.jianshu.io/upload_images/1972799-3d6ffa72374a174e.png?imageMogr2/auto-orient/strip|imageView2/2/w/803/format/webp)

debugserver在Xcode里的位置



![img](https://upload-images.jianshu.io/upload_images/1972799-3dab98b97caaeead.png?imageMogr2/auto-orient/strip|imageView2/2/w/714/format/webp)

debugserver在手机里的位置



目前Xcode只能连接它所运行的App，那么如何调试手机上已经安装的App呢,通过Xcode肯定不行了。我们只能用LLDB终端来进行了，下面看我们该如何做。

##### 三 调试任意第三方App

上面我们知道，要想动态调试一个App只能通过Xcode安装运行的，为什么会这样呢，那是因为debugserver权限被限制了，那么要想调试别的App，就需要给debugserver附加额外的权限，我们主要添加下面两个权限：
**get-task-allow：**布尔类型，是否允许其他进程（比如调试器），附加到你的应用程序上。
**task_for_pid-allow：**布尔类型，是否允许通过进程ID获取任务
加上这两个权限之后我们的debugserver就能够访问任何App的权限了，如何附加这两个权限，主要有这几步。

###### 1 利用ldid导出debugeserver权限描述文件

把手机/Developer/usr/bin/debugserver拷贝一份到到电脑桌面，然后调用如下命令

```ruby
 xmldeMacBook-Pro:Desktop xml$ ldid -e debugserver  >  debugserver.entitlements
```

###### 2 打开导出的描述文件添加权限



![img](https://upload-images.jianshu.io/upload_images/1972799-a3468567c10de16f.png?imageMogr2/auto-orient/strip|imageView2/2/w/483/format/webp)

###### 3 利用codesign重新给debugserver签名

```ruby
xmldeMacBook-Pro:Desktop xml$ codesign -s - --entitlements debugserver.entitlements -f debugserver
debugserver: replacing existing signature
```

###### 4 查看是否签名成功

```xml
xmldeMacBook-Pro:Desktop xml$ ldid -e debugserver

<?xml version="1.0" encoding="UTF-8"?>

<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "[http://www.apple.com/DTDs/PropertyList-1.0.dtd](http://www.apple.com/DTDs/PropertyList-1.0.dtd)">

<plist version="1.0">

<dict>

    <key>get-task-allow</key>

    <true/>

    <key>task_for_pid-allow</key>

    <true/>

    <key>com.apple.developer.ubiquity-container-identifiers</key>

    <string></string>

    <key>com.apple.backboardd.debugapplications</key>

    <true/>

    <key>com.apple.backboardd.launchapplications</key>

    <true/>

    <key>com.apple.diagnosticd.diagnostic</key>

    <true/>

    <key>com.apple.frontboard.debugapplications</key>

    <true/>

    <key>com.apple.frontboard.launchapplications</key>

    <true/>

    <key>[com.apple.security.network.client](http://com.apple.security.network.client/)</key>

    <true/>

    <key>[com.apple.security.network.server](http://com.apple.security.network.server/)</key>

    <true/>

    <key>com.apple.springboard.debugapplications</key>

    <true/>

    <key>run-unsigned-code</key>

    <true/>

    <key>seatbelt-profiles</key>

    <array>

        <string>debugserver</string>

    </array>

</dict>

</plist>
```

我们看刚添加的权限已经添加上了，添加权限就这么几步，我们把接下来的流程走完，看看如何去动态调试第三方App

###### 5 把重签权限的debugserver放到手机/Device/usr/bin目录下



![img](https://upload-images.jianshu.io/upload_images/1972799-a4b99693c8486fcf.png?imageMogr2/auto-orient/strip|imageView2/2/w/738/format/webp)

###### 6 给debugserver执行权限

```bash
applede-iPhone:/ root# chmod +x /usr/bin/debugserver
```

###### 7 通过USB转接debugserver的连接端口

连接debugserver，需要指定一个端口号，我们跟ssh远程登录手机一样，我们也用usbmuxd做一下转接

```bash
xmldeMacBook-Pro:~ xml$ python /Users/xml/Desktop/python-client/tcprelay.py -t 22:10001 11111:11111
Forwarding local port 10001 to remote port 22
Forwarding local port 11111 to remote port 11111
Incoming connection to 10010
Waiting for devices...
Connecting to device <MuxDevice: ID 7 ProdID 0x12a8 Serial 'e567d7aa5cc942955b30d0d95128c964cdfacc01' Location 0x14200000>
Connection established, relaying data
```

10001是我们映射的远程登录手机的端口，11111是我们映射的连接debugserver的端口。

###### 8 把debugserver附加的某个APP进程上

debugserver *:端口号 -a 进程

```python
applede-iPhone:/ root# debugserver *:11111 -a WeChat
debugserver-@(#)PROGRAM:debugserver  PROJECT:debugserver-360.0.26.1
 for arm64.
Attaching to process WeChat...
Listening to port 11111 for a connection from *…
```

我把它附加到微信的进程上，注意这里你的手机要打开微信App，我们说一下命令的两个参数。
**端口号：**就是使用手机的某个端口启动debugserver，刚才我们用usbmuxd映射的是11111这个端口，那么这里我们也用11111这个端口来启动debugserver.
**进程：**这里的进程就是App的进程ID或者进程名称

###### 9 Mac上个启动LLDB，远程连接iPhone上的debugserver服务。

```csharp
xmldeMacBook-Pro:~ xml$ lldb

(lldb) process connect [connect://localhost:11111](connect://localhost:11111)

Process 23254 stopped

* thread #1, queue = 'com.apple.main-thread', stop reason = signal SIGSTOP

    frame #0: 0x0000000184e89188 libsystem_kernel.dylib`mach_msg_trap + 8

libsystem_kernel.dylib`mach_msg_trap:

->  0x184e89188 <+8>: ret

libsystem_kernel.dylib`mach_msg_overwrite_trap:

    0x184e8918c <+0>: mov    x16, #-0x20

    0x184e89190 <+4>: svc    #0x80

    0x184e89194 <+8>: ret

Target 0: (WeChat) stopped.

(lldb) c

Process 23254 resuming
```

到此调试任意App的整个环境流程就完了，接下来就是输入LLDB命令开始调试了，一开始连接好，是要在LLDB终端输入c命令才能继续调试。
最后补充下，如何通过debugserver直接启动一个App

```cpp
$ debugserver -x auto *:端口号 APP的可执行文件路径
 applede-iPhone:/ root# debugserver -x auto *:11111 
```

##### 四 LLDB简介

[LLDB](http://lldb.llvm.org/)是Mac OS X上Xcode的默认调试器，支持在桌面和iOS设备和模拟器上调试C，Objective-C和C ++,这里我们主要讲解一些它的常用命令。

###### LLDB指令格式

```xml
<command> [<subcommand> [<subcommand>...]] <action> [-options [option-
value]] [argument [argument...]]
```

<command>: 命令
[<subcommand> [<subcommand>...]] : 子命令
<action>: 命令操作
[-options [option-value]]: 命令选项
[argument [argument...]]:命令参数

下面是一个使用示例



![img](https://upload-images.jianshu.io/upload_images/1972799-ac0467e6a92023a1.png?imageMogr2/auto-orient/strip|imageView2/2/w/743/format/webp)

breakpoint: 命令
list : 子命令
-v : 命令操作
2:命令参数
LLDB命令格式基本格式都是这样的，命令的子命令，命令操作，命令选项，命令参数都是可选项，那么格式就是这样的，接下来我们看一下，常用的一些命令。

###### 1 帮助命令 help

如果遇到一个指令你不知道怎么用,那么就使用help命令查看它的一些详细用法

```bash
(lldb) help breakpoint
     Commands for operating on breakpoints (see 'help b' for shorthand.)

Syntax: breakpoint <subcommand> [<command-options>]

The following subcommands are supported:

      clear   -- Delete or disable breakpoints matching the specified source
                 file and line.
      command -- Commands for adding, removing and listing LLDB commands
                 executed when a breakpoint is hit.
      delete  -- Delete the specified breakpoint(s).  If no breakpoints are
                 specified, delete them all.
      disable -- Disable the specified breakpoint(s) without deleting them.  If
                 none are specified, disable all breakpoints.
      enable  -- Enable the specified disabled breakpoint(s). If no breakpoints
                 are specified, enable all of them.
      list    -- List some or all breakpoints at configurable levels of detail.
      modify  -- Modify the options on a breakpoint or set of breakpoints in
                 the executable.  If no breakpoint is specified, acts on the
                 last created breakpoint.  With the exception of -e, -d and -i,
                 passing an empty argument clears the modification.
      name    -- Commands to manage name tags for breakpoints
      read    -- Read and set the breakpoints previously saved to a file with
                 "breakpoint write".  
      set     -- Sets a breakpoint or set of breakpoints in the executable.
      write   -- Write the breakpoints listed to a file that can be read in
                 with "breakpoint read".  If given no arguments, writes all
                 breakpoints.

For more help on any particular subcommand, type 'help <command> <subcommand>'.
(lldb) help po
     Evaluate an expression on the current thread.  Displays any returned value
     with formatting controlled by the type's author.  Expects 'raw' input (see
     'help raw-input'.)
Syntax: po <expr>
Command Options Usage:
  po <expr>
'po' is an abbreviation for 'expression -O  --'
(lldb) 
```

###### 2 表达式命令 expression --

执行一个表达式，任何可执行的OC代码行
-- :是命令选项结束符，标示所有命令选项已经设置完毕，如果没有命令选项，--可以不用写

```objectivec
(lldb) expression NSLog(@"已经越狱")
2019-03-09 16:16:01.565070+0800 test[3156:116239] 已经越狱
(lldb) expression -A -- self.view
(UIView *) $1 = 0x00007f9655c04060 
(lldb) expression self.view.backgroundColor = [UIColor redColor]
(UICachedDeviceRGBColor *) $0 = 0x00006000013004c0
```

使用表达式命令，我们就可以动态添加代码执行，比如我们有两个视图叠加一块了，但是我们想知道一个视图有没有被遮挡，我们就可以使用表达式命令，给其中一个视图添加一个颜色，这样我们就能区分了，再也不用手动写一下代码，然后再重新执行一下了。

###### expression，expression --和指令print，p，call效果都是一样的

```objectivec
(lldb) expression self.view.backgroundColor = [UIColor redColor]
(UICachedDeviceRGBColor *) $0 = 0x00006000013004c0
(lldb) expression self.view
(UIView *) $1 = 0x00007fb7f3703700
(lldb) p self.view
(UIView *) $2 = 0x00007fb7f3703700
(lldb) print self.view
(UIView *) $3 = 0x00007fb7f3703700
(lldb) call self.view
(UIView *) $4 = 0x00007fb7f3703700
(lldb) 
```

我们经常用p 来执行表达式命令，比写expression要少好多字符是吧。

###### expression -O --和指令po的效果都是一样的用来打印对象本身

```objectivec
(lldb) expression -o -- self.view
<UIView: 0x7fb7f3703700; frame = (0 0; 414 896); autoresize = W+H; layer = <CALayer: 0x600000677500>>

(lldb) po self.view
<UIView: 0x7fb7f3703700; frame = (0 0; 414 896); autoresize = W+H; layer = <CALayer: 0x600000677500>>
```

为什么效果都是一样，因为他们都是expression命令一些操作的别名，本身就是一个东西，相当于起了个外号，方便好记好用。

###### 3 thread backtrace 打印线程的堆栈信息，别名bt

```objectivec
(lldb) thread backtrace
* thread #1, queue = 'com.apple.main-thread', stop reason = breakpoint 1.1
  * frame #0: 0x00000001010e9884 test`-[ViewController viewDidLoad](self=0x00007fb7f37023f0, _cmd="viewDidLoad") at ViewController.m:16
    frame #1: 0x0000000104cb64e1 UIKitCore`-[UIViewController loadViewIfRequired] + 1186
    frame #2: 0x0000000104cb6940 UIKitCore`-[UIViewController view] + 27
    frame #3: 0x000000010530dc53 UIKitCore`-[UIWindow addRootViewControllerViewIfPossible] + 122
    frame #4: 0x000000010530e36e UIKitCore`-[UIWindow _setHidden:forced:] + 294
    frame #5: 0x00000001053215c0 UIKitCore`-[UIWindow makeKeyAndVisible] + 42
    frame #6: 0x00000001052ce833 UIKitCore`-[UIApplication _callInitializationDelegatesForMainScene:transitionContext:] + 4595
    frame #7: 0x00000001052d3c2f UIKitCore`-[UIApplication _runWithMainScene:transitionContext:completion:] + 1623
    frame #8: 0x0000000104af24e9 UIKitCore`__111-[__UICanvasLifecycleMonitor_Compatability _scheduleFirstCommitForScene:transition:firstActivation:completion:]_block_invoke + 866
    frame #9: 0x0000000104afb29c UIKitCore`+[_UICanvas _enqueuePostSettingUpdateTransactionBlock:] + 153
    frame #10: 0x0000000104af2126 UIKitCore`-[__UICanvasLifecycleMonitor_Compatability _scheduleFirstCommitForScene:transition:firstActivation:completion:] + 233
    frame #11: 0x0000000104af2ae0 UIKitCore`-[__UICanvasLifecycleMonitor_Compatability activateEventsOnly:withContext:completion:] + 1085
    frame #12: 0x0000000104af0cb5 UIKitCore`__82-[_UIApplicationCanvas _transitionLifecycleStateWithTransitionContext:completion:]_block_invoke + 795
    frame #13: 0x0000000104af095f UIKitCore`-[_UIApplicationCanvas _transitionLifecycleStateWithTransitionContext:completion:] + 435
    frame #14: 0x0000000104af5a90 UIKitCore`__125-[_UICanvasLifecycleSettingsDiffAction performActionsForCanvas:withUpdatedScene:settingsDiff:fromSettings:transitionContext:]_block_invoke + 584
    frame #15: 0x0000000104af680e UIKitCore`_performActionsWithDelayForTransitionContext + 100
    frame #16: 0x0000000104af57ef UIKitCore`-[_UICanvasLifecycleSettingsDiffAction performActionsForCanvas:withUpdatedScene:settingsDiff:fromSettings:transitionContext:] + 221
    frame #17: 0x0000000104afa93a UIKitCore`-[_UICanvas scene:didUpdateWithDiff:transitionContext:completion:] + 392
    frame #18: 0x00000001052d244e UIKitCore`-[UIApplication workspace:didCreateScene:withTransitionContext:completion:] + 515
    frame #19: 0x0000000104e76d09 UIKitCore`-[UIApplicationSceneClientAgent scene:didInitializeWithEvent:completion:] + 357
    frame #20: 0x000000010db0f2da FrontBoardServices`-[FBSSceneImpl _didCreateWithTransitionContext:completion:] + 448
    frame #21: 0x000000010db1a443 FrontBoardServices`__56-[FBSWorkspace client:handleCreateScene:withCompletion:]_block_invoke_2 + 271
    frame #22: 0x000000010db19b3a FrontBoardServices`__40-[FBSWorkspace _performDelegateCallOut:]_block_invoke + 53
    frame #23: 0x0000000103d6d602 libdispatch.dylib`_dispatch_client_callout + 8
    frame #24: 0x0000000103d70b78 libdispatch.dylib`_dispatch_block_invoke_direct + 301
    frame #25: 0x000000010db4eba8 FrontBoardServices`__FBSSERIALQUEUE_IS_CALLING_OUT_TO_A_BLOCK__ + 30
    frame #26: 0x000000010db4e860 FrontBoardServices`-[FBSSerialQueue _performNext] + 457
    frame #27: 0x000000010db4ee40 FrontBoardServices`-[FBSSerialQueue _performNextFromRunLoopSource] + 45
    frame #28: 0x00000001023d4721 CoreFoundation`__CFRUNLOOP_IS_CALLING_OUT_TO_A_SOURCE0_PERFORM_FUNCTION__ + 17
    frame #29: 0x00000001023d3f93 CoreFoundation`__CFRunLoopDoSources0 + 243
    frame #30: 0x00000001023ce63f CoreFoundation`__CFRunLoopRun + 1263
    frame #31: 0x00000001023cde11 CoreFoundation`CFRunLoopRunSpecific + 625
    frame #32: 0x0000000109a661dd GraphicsServices`GSEventRunModal + 62
    frame #33: 0x00000001052d581d UIKitCore`UIApplicationMain + 140
    frame #34: 0x00000001010e99c0 test`main(argc=1, argv=0x00007ffeeeb16088) at main.m:14
    frame #35: 0x0000000103de3575 libdyld.dylib`start + 1
    frame #36: 0x0000000103de3575 libdyld.dylib`start + 1
(lldb) bt
* thread #1, queue = 'com.apple.main-thread', stop reason = breakpoint 1.1
  * frame #0: 0x00000001010e9884 test`-[ViewController viewDidLoad](self=0x00007fb7f37023f0, _cmd="viewDidLoad") at ViewController.m:16
    frame #1: 0x0000000104cb64e1 UIKitCore`-[UIViewController loadViewIfRequired] + 1186
    frame #2: 0x0000000104cb6940 UIKitCore`-[UIViewController view] + 27
    frame #3: 0x000000010530dc53 UIKitCore`-[UIWindow addRootViewControllerViewIfPossible] + 122
    frame #4: 0x000000010530e36e UIKitCore`-[UIWindow _setHidden:forced:] + 294
    frame #5: 0x00000001053215c0 UIKitCore`-[UIWindow makeKeyAndVisible] + 42
    frame #6: 0x00000001052ce833 UIKitCore`-[UIApplication _callInitializationDelegatesForMainScene:transitionContext:] + 4595
    frame #7: 0x00000001052d3c2f UIKitCore`-[UIApplication _runWithMainScene:transitionContext:completion:] + 1623
    frame #8: 0x0000000104af24e9 UIKitCore`__111-[__UICanvasLifecycleMonitor_Compatability _scheduleFirstCommitForScene:transition:firstActivation:completion:]_block_invoke + 866
    frame #9: 0x0000000104afb29c UIKitCore`+[_UICanvas _enqueuePostSettingUpdateTransactionBlock:] + 153
    frame #10: 0x0000000104af2126 UIKitCore`-[__UICanvasLifecycleMonitor_Compatability _scheduleFirstCommitForScene:transition:firstActivation:completion:] + 233
    frame #11: 0x0000000104af2ae0 UIKitCore`-[__UICanvasLifecycleMonitor_Compatability activateEventsOnly:withContext:completion:] + 1085
    frame #12: 0x0000000104af0cb5 UIKitCore`__82-[_UIApplicationCanvas _transitionLifecycleStateWithTransitionContext:completion:]_block_invoke + 795
    frame #13: 0x0000000104af095f UIKitCore`-[_UIApplicationCanvas _transitionLifecycleStateWithTransitionContext:completion:] + 435
    frame #14: 0x0000000104af5a90 UIKitCore`__125-[_UICanvasLifecycleSettingsDiffAction performActionsForCanvas:withUpdatedScene:settingsDiff:fromSettings:transitionContext:]_block_invoke + 584
    frame #15: 0x0000000104af680e UIKitCore`_performActionsWithDelayForTransitionContext + 100
    frame #16: 0x0000000104af57ef UIKitCore`-[_UICanvasLifecycleSettingsDiffAction performActionsForCanvas:withUpdatedScene:settingsDiff:fromSettings:transitionContext:] + 221
    frame #17: 0x0000000104afa93a UIKitCore`-[_UICanvas scene:didUpdateWithDiff:transitionContext:completion:] + 392
    frame #18: 0x00000001052d244e UIKitCore`-[UIApplication workspace:didCreateScene:withTransitionContext:completion:] + 515
    frame #19: 0x0000000104e76d09 UIKitCore`-[UIApplicationSceneClientAgent scene:didInitializeWithEvent:completion:] + 357
    frame #20: 0x000000010db0f2da FrontBoardServices`-[FBSSceneImpl _didCreateWithTransitionContext:completion:] + 448
    frame #21: 0x000000010db1a443 FrontBoardServices`__56-[FBSWorkspace client:handleCreateScene:withCompletion:]_block_invoke_2 + 271
    frame #22: 0x000000010db19b3a FrontBoardServices`__40-[FBSWorkspace _performDelegateCallOut:]_block_invoke + 53
    frame #23: 0x0000000103d6d602 libdispatch.dylib`_dispatch_client_callout + 8
    frame #24: 0x0000000103d70b78 libdispatch.dylib`_dispatch_block_invoke_direct + 301
    frame #25: 0x000000010db4eba8 FrontBoardServices`__FBSSERIALQUEUE_IS_CALLING_OUT_TO_A_BLOCK__ + 30
    frame #26: 0x000000010db4e860 FrontBoardServices`-[FBSSerialQueue _performNext] + 457
    frame #27: 0x000000010db4ee40 FrontBoardServices`-[FBSSerialQueue _performNextFromRunLoopSource] + 45
    frame #28: 0x00000001023d4721 CoreFoundation`__CFRUNLOOP_IS_CALLING_OUT_TO_A_SOURCE0_PERFORM_FUNCTION__ + 17
    frame #29: 0x00000001023d3f93 CoreFoundation`__CFRunLoopDoSources0 + 243
    frame #30: 0x00000001023ce63f CoreFoundation`__CFRunLoopRun + 1263
    frame #31: 0x00000001023cde11 CoreFoundation`CFRunLoopRunSpecific + 625
    frame #32: 0x0000000109a661dd GraphicsServices`GSEventRunModal + 62
    frame #33: 0x00000001052d581d UIKitCore`UIApplicationMain + 140
    frame #34: 0x00000001010e99c0 test`main(argc=1, argv=0x00007ffeeeb16088) at main.m:14
    frame #35: 0x0000000103de3575 libdyld.dylib`start + 1
    frame #36: 0x0000000103de3575 libdyld.dylib`start + 1
(lldb) 
```

显示线程调用堆栈。 默认为当前线程，线程索引可以指定为参数。使用thread-index“all”查看所有线程。使用thread-index“unique”查看按唯一调用堆栈分组的线程。

###### 4 thread return [] 让函数直接返回某个值，不会在执行断点后的代码



![img](https://upload-images.jianshu.io/upload_images/1972799-eb60c3496b195461.png?imageMogr2/auto-orient/strip|imageView2/2/w/689/format/webp)

我们在27行断点处执行 thread return 命令，那么即使29行有代码断点，他也不会执行，而是直接跳到19行断点处，thread return应该是当前函数体内下面的代码不会执行了，但是函数体外的流程还是会接着执行的。

###### 5 frame variable [] 打印当前栈帧的变量

```cpp
(lldb) frame variable
(ViewController *) self = 0x00007fa4e970ce90
(SEL) _cmd = "viewDidLoad"
```

如果想了解此命令的其他用法，可以调用帮助命令查看一下，
** help frame variable **

###### 6断点执行的一些命令



![img](https://upload-images.jianshu.io/upload_images/1972799-1f54d5b4af1fee8b.png?imageMogr2/auto-orient/strip|imageView2/2/w/422/format/webp)

上面Xcode一些断点调试的按钮我们应该很熟悉吧，那么它具体执行的是LLDB的什么命令呢，我们来看一下。

| 命令                  | 命令简写    | 功能描述                                         |
| --------------------- | ----------- | ------------------------------------------------ |
| thread continue       | continue，c | 程序继续运行                                     |
| thread step-over      | next，n     | 单步执行，遇到函数不会进入到函数里面             |
| thread step-in        | step，s     | 单步执行，遇到函数会进到函数从里面               |
| thread step-out       | finish      | 在这个函数体内，当前断点的代码不在执行，直接跳过 |
| thread step-inst-over | nexti，ni   | 类似与thread step-over的功能，不过它是汇编级别的 |
| thread step-inst      | stepi，si   | 类似thread step-in的功能，它也是汇编级别的       |

什么是汇编级别的，一行源代码，编译成汇编有可能有好几行，调试这行源代码的汇编代码时，是一行一行的执行，还是一次性执行完这几行呢，那么就用到thread step-inst-over，thread step-inst命令了。

###### 7 断点的查找添加删除禁用启用等操作

| 命令                               | 功能描述                                                 |
| ---------------------------------- | -------------------------------------------------------- |
| breakpoint set                     | 设置断点                                                 |
| breakpoint list                    | 列出所有断点                                             |
| breakpoint disable 断点编号        | 禁用断点                                                 |
| breakpoint enable 断点编号         | 启用断点                                                 |
| breakpoint delete 断点编号         | 删除断点                                                 |
| breakpoint command add 断点编号    | 给断点预先设置需要执行的命令，到触发点时，就会安顺序执行 |
| breakpoint command delete 断点编号 | 查看某个断点设置的命令                                   |
| breakpoint command delete 断点编号 | 删除某个断点设置的命令                                   |

操作命令用法跟下面的内存断点示例差不多，在此就不演示了。

###### 8 内存断点

watchpoint set variable 变量
watchpoint set variable self->age
watchpoint set expression 地址
watchpoint set expression &(self->_age)
watchpoint list
watchpoint disable 断点编号
watchpoint enable 断点编号
watchpoint delete 断点编号
watchpoint command add 断点编号
watchpoint command list 断点编号
watchpoint command delete 断点编号

示例代码

```objectivec
#import "ViewController.h"
@interface ViewController ()

@end
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    int i = 10;
    NSString *str = @"hello";
    [self sayHello];
    if([[NSFileManager defaultManager] fileExistsAtPath:@"/Applications/Cydia.app"]) {
        NSLog(@"手机已越狱");
    }else {
        NSLog(@"手机未越狱");
    }
}

- (void) sayHello{
    NSLog(@"hello");
   
    NSLog(@"world");
}
@end
```

操作命令

```tsx
(lldb) watchpoint list
Number of supported hardware watchpoints: 4
No watchpoints currently set.
(lldb) watchpoint set variable i
Watchpoint created: Watchpoint 1: addr = 0x7ffeeadaaa7c size = 4 state = enabled type = w
    declare @ '/Users/xml/Documents/cocoaPodStudy/test/test/ViewController.m:17'
    watchpoint spec = 'i'
    new value: 10
(lldb) watchpoint set variable &str
Watchpoint created: Watchpoint 2: addr = 0x7ffeeadaaa70 size = 8 state = enabled type = w
    declare @ '/Users/xml/Documents/cocoaPodStudy/test/test/ViewController.m:18'
    watchpoint spec = '&str'
    new value: 0x0000000104e56210
(lldb) watchpoint list
Number of supported hardware watchpoints: 4
Current watchpoints:
Watchpoint 1: addr = 0x7ffeeadaaa7c size = 4 state = enabled type = w
    declare @ '/Users/xml/Documents/cocoaPodStudy/test/test/ViewController.m:17'
    watchpoint spec = 'i'
    new value: 10
Watchpoint 2: addr = 0x7ffeeadaaa70 size = 8 state = enabled type = w
    declare @ '/Users/xml/Documents/cocoaPodStudy/test/test/ViewController.m:18'
    watchpoint spec = '&str'
    new value: 0x0000000104e56210
(lldb) watchpoint disable 1
1 watchpoints disabled.
(lldb) watchpoint enable 2
1 watchpoints enabled.
(lldb) watchpoint delete 1
1 watchpoints deleted.
(lldb) watchpoint list
Number of supported hardware watchpoints: 4
Current watchpoints:
Watchpoint 2: addr = 0x7ffeeadaaa70 size = 8 state = enabled type = w
    declare @ '/Users/xml/Documents/cocoaPodStudy/test/test/ViewController.m:18'
    watchpoint spec = '&str'
    new value: 0x0000000104e56210
(lldb) watchpoint command add 2
Enter your debugger command(s).  Type 'DONE' to end.
> po self
> DONE
(lldb) watchpoint command list 2
Watchpoint 2:
    watchpoint commands:
      po self
(lldb) watchpoint command delete 2
(lldb) watchpoint command list
error: No watchpoint specified for which to list the commands
(lldb)
```

###### 9 镜像/模块操作

image lookup
image lookup -t 类型：查找某个类型的信息
image lookup -a 地址：根据内存地址查找在模块中的位置
image lookup -n 符号或者函数名：查找某个符号或者函数的位置
image list 列出所加载的模块信息
image list -o -f 打印出模块的偏移地址，全路径。
代码

```objectivec
#import "ViewController.h"
@interface ViewController ()
@end
@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    int i = 10;
    NSString *str = @"hello";
    [self sayHello];
    if([[NSFileManager defaultManager] fileExistsAtPath:@"/Applications/Cydia.app"]) {
        NSLog(@"手机已越狱");
    }else {
        NSLog(@"手机未越狱");
    }
}

- (void) sayHello{
    NSLog(@"hello");
   
    NSLog(@"world");
}
@end
```

操作命令示例

```csharp
(lldb) image lookup -t int
Best match found in /Users/xml/Library/Developer/Xcode/DerivedData/test-gkdxuwrmexrlikdlqtxkfhhftvpq/Build/Products/Debug-iphonesimulator/test.app/test:
id = {0x10000011b}, name = "int", byte-size = 4, compiler_type = "int"

(lldb) image lookup -a 0x0000000104e56210
      Address: test[0x0000000100005210] (test.__DATA.__cfstring + 0)
      Summary: @"hello"
(lldb) image lookup -n sayHello
1 match found in /Users/xml/Library/Developer/Xcode/DerivedData/test-gkdxuwrmexrlikdlqtxkfhhftvpq/Build/Products/Debug-iphonesimulator/test.app/test:
        Address: test[0x0000000100001900] (test.__TEXT.__text + 288)
        Summary: test`-[ViewController sayHello] at ViewController.m:27
(lldb) image list
[  0] D57D8BF5-6F5D-3693-8C31-F36213F33C8B 0x0000000104e51000 /Users/xml/Library/Developer/Xcode/DerivedData/test-gkdxuwrmexrlikdlqtxkfhhftvpq/Build/Products/Debug-iphonesimulator/test.app/test 
[  1] D6387150-2FB8-3066-868D-72E1B1C43982 0x000000010a7eb000 /usr/lib/dyld 
[  2] C3514384-926E-3813-BF0C-69FFC704E283 0x0000000104e62000 /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/Library/CoreSimulator/Profiles/Runtimes/iOS.simruntime/Contents/Resources/RuntimeRoot/usr/lib/dyld_sim 
[  3] E5391C7B-0161-33AF-A5A7-1E18DBF9041F 0x000000010514b000 /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/Library/CoreSimulator/Profiles/Runtimes/iOS.simruntime/Contents/Resources/RuntimeRoot/System/Library/Frameworks/Foundation.framework/Foundation 
[  4] 177A61B3-9E02-3A09-9A98-C1C3C9AB7958 0x0000000105771000 /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/Library/CoreSimulator/Profiles/Runtimes/iOS.simruntime/Contents/Resources/RuntimeRoot/usr/lib/libobjc.A.dylib 
[  5] C89C657A-9BD2-3C7D-AD2E-ACF00916BF7D 0x00000001060a8000 /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/Library/CoreSimulator/Profiles/Runtimes/iOS.simruntime/Contents/Resources/RuntimeRoot/usr/lib/libSystem.B.dylib 
(lldb) image list -o -f
[  0] 0x0000000004e51000 /Users/xml/Library/Developer/Xcode/DerivedData/test-gkdxuwrmexrlikdlqtxkfhhftvpq/Build/Products/Debug-iphonesimulator/test.app/test
[  1] 0x000000010a7eb000 /usr/lib/dyld
[  2] 0x0000000104e62000 /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/Library/CoreSimulator/Profiles/Runtimes/iOS.simruntime/Contents/Resources/RuntimeRoot/usr/lib/dyld_sim
[  3] 0x000000010514b000 /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/Library/CoreSimulator/Profiles/Runtimes/iOS.simruntime/Contents/Resources/RuntimeRoot/System/Library/Frameworks/Foundation.framework/Foundation
[  4] 0x0000000105771000 /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/Library/CoreSimulator/Profiles/Runtimes/iOS.simruntime/Contents/Resources/RuntimeRoot/usr/lib/libobjc.A.dylib
[  5] 0x00000001060a8000 /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/Library/CoreSimulator/Profiles/Runtimes/iOS.simruntime/Contents/Resources/RuntimeRoot/usr/lib/libSystem.B.dylib
[  6] 0x00000001060b0000 /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/Library/CoreSimulator/Profiles/Runtimes/iOS.simruntime/Contents/Resources/RuntimeRoot/System/Library/Frameworks/CoreFoundation.framework/CoreFoundation
```



1人点赞

iOS逆向工程