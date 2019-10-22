# 七 iOS逆向 - Cycript

0.8852019.02.23 20:32:36字数 1625阅读 527



![img](https://upload-images.jianshu.io/upload_images/1972799-e04bab076948ccf0.png?imageMogr2/auto-orient/strip|imageView2/2/w/755/format/webp)

- Cycript简介
- Cycript基本使用
- 封装Cycript脚本
- Cycript使用示例

##### 一 Cycript简介

Cycript允许开发人员使用Objective-C ++和JavaScript语法的混合，通过具有语法突出显示和制表符完成功能的交互式控制台，可以用来探索、修改、调试正在运行的Mac\iOS APP
（它还可以在Android和Linux上独立运行，并提供对Java的访问，但不需要注入。）
Cycript 官方网址[http://www.cycript.org](http://www.cycript.org/)





通过Cydia安装Cycript，即可在iPhone上调试运行中的APP,安装步骤如下图



![img](https://upload-images.jianshu.io/upload_images/1972799-c0924ef358f8559f.png?imageMogr2/auto-orient/strip|imageView2/2/w/848/format/webp)

然后我们登录到手机就可以使用了

```bash
applede-iPhone:~ root# cy
cycc     cycript  cynject
applede-iPhone:~ root# cycript
cy# 1+1
2
cy#
```

通过安装界面我们可以知道Cycript是由Jay Freeman开发的，没错他就是Cydia的作者，Cycript主要用来探索、修改、调试正在运行的Mac\iOS APP的，现在工具我们已经安装好了，那么我们该怎么去调试一个iOS App应用呢？我们接着往下看。

##### 二 Cycript基本使用

下面我们以调试一个爱奇艺app来看一下它的简单使用流程

###### 2.1 使用流程

###### 步骤一 安装adv-cmds，为了查看进程需要ps命令，所以需要安装这个插件



![img](https://upload-images.jianshu.io/upload_images/1972799-12fc5d020af0cab5.png?imageMogr2/auto-orient/strip|imageView2/2/w/295/format/webp)

手机上安装这个插件

###### 步骤二 查找爱奇艺这个应用的进程，前提是你的手机要打开这个应用

```bash
applede-iPhone:~ root# ps -A
  PID TTY           TIME CMD
    1 ??         7:45.21 /sbin/launchd
   21 ??         0:58.51 /usr/sbin/syslogd
   42 ??         3:58.87 /usr/libexec/logd
  685 ??         0:14.17 /System/Library/PrivateFrameworks/AssistantServices.framework/assistantd
  687 ??         0:34.87 /usr/libexec/fseventsd
  689 ??         1:07.56 /usr/sbin/mediaserverd
  695 ??         0:31.61 /usr/libexec/routined
  699 ??         0:59.72 /usr/libexec/configd
  701 ??         0:06.32 /System/Library/Frameworks/HealthKit.framework/healthd
  703 ??         1:38.31 /System/Library/CoreServices/powerd.bundle/powerd
  711 ??         0:04.43 /usr/libexec/keybagd -t 15
  719 ??         1:22.97 /usr/sbin/wifid
  725 ??         0:47.07 /System/Library/PrivateFrameworks/IDS.framework/identityservicesd.app/identityservicesd
  741 ??         0:00.73 /usr/sbin/wirelessproxd
  745 ??         0:06.65 /usr/libexec/sharingd
  747 ??         0:21.23 /usr/libexec/timed
  749 ??        21:19.84 /usr/libexec/locationd
  751 ??         0:04.53 /usr/sbin/BTServer
  753 ??         0:14.06 /System/Library/PrivateFrameworks/IMCore.framework/imagent.app/imagent
  755 ??         0:20.56 /usr/libexec/assertiond
  759 ??         0:00.25 /usr/libexec/tipsd
  761 ??         8:39.53 /usr/libexec/UserEventAgent (System)
  763 ??         7:22.66 /usr/libexec/lockdownd
  767 ??         0:31.36 /System/Library/PrivateFrameworks/IAP.framework/Support/iaptransportd
  779 ??         0:09.82 /usr/sbin/fairplayd.H2
  781 ??         9:36.63 /System/Library/Frameworks/CoreTelephony.framework/Support/CommCenter
  792 ??         2:58.75 /usr/sbin/notifyd
  808 ??         1:42.85 /usr/sbin/cfprefsd daemon
  811 ??         1:09.30 /usr/sbin/distnoted daemon
  813 ??         1:05.38 /usr/libexec/lsd
  833 ??         0:11.55 /System/Library/PrivateFrameworks/WirelessDiagnostics.framework/Support/awdd
  836 ??         8:35.88 /usr/libexec/securityd
  840 ??         4:08.65 /usr/libexec/nehelper
  842 ??         0:01.53 /usr/sbin/WirelessRadioManagerd
  847 ??         2:46.70 /usr/libexec/coreduetd
  858 ??         0:38.76 /usr/libexec/lockbot
  868 ??         3:20.95 /System/Library/PrivateFrameworks/ApplePushService.framework/apsd
  877 ??         1:16.26 /usr/libexec/hangtracerd
  891 ??        11:34.58 /System/Library/Frameworks/Accounts.framework/accountsd
  895 ??         0:38.13 /System/Library/PrivateFrameworks/iTunesStore.framework/Support/itunesstored
  907 ??         0:02.71 /System/Library/PrivateFrameworks/TCC.framework/tccd
  915 ??         0:57.96 /usr/sbin/mDNSResponder
  918 ??         0:35.55 /usr/libexec/nsurlsessiond
  931 ??         0:14.15 /System/Library/PrivateFrameworks/TelephonyUtilities.framework/callservicesd
  936 ??         1:03.62 /usr/libexec/DuetHeuristic-BM
  939 ??         0:28.37 /usr/libexec/nsurlstoraged
  948 ??         1:28.61 /usr/libexec/symptomsd
  976 ??         1:07.50 /usr/libexec/nesessionmanager
  980 ??         0:08.33 /System/Library/TextInput/kbd
  983 ??         0:38.32 /System/Library/PrivateFrameworks/DataAccess.framework/Support/dataaccessd
  989 ??         0:01.93 /usr/libexec/biometrickitd --launchd
 1015 ??         1:25.70 /System/Library/PrivateFrameworks/CloudDocsDaemon.framework/bird
 1036 ??         2:55.34 /System/Library/PrivateFrameworks/CloudKitDaemon.framework/Support/cloudd
 1048 ??         0:07.45 /System/Library/PrivateFrameworks/ManagedConfiguration.framework/Support/profiled
 1055 ??         0:03.77 /System/Library/PrivateFrameworks/UserActivity.framework/Agents/useractivityd
 1061 ??         0:09.41 /usr/libexec/duetexpertd
 1078 ??         0:00.05 /usr/libexec/captiveagent
 1098 ??         0:00.25 /usr/sbin/filecoordinationd
 1141 ??         0:08.62 /System/Library/PrivateFrameworks/AssetCacheServices.framework/XPCServices/AssetCacheLocatorService.xpc/AssetCacheLocatorService -d
 1601 ??         0:00.56 /usr/libexec/afcd
 1868 ??         0:09.41 /usr/libexec/notification_proxy
 2105 ??         2:15.42 /System/Library/PrivateFrameworks/PhotoAnalysis.framework/Support/photoanalysisd
 4026 ??         0:00.63 /usr/libexec/dprivacyd
15319 ??         0:09.81 /System/Library/PrivateFrameworks/AppStoreDaemon.framework/appstored.bundle/appstored
15382 ??         0:22.13 /usr/libexec/atc
15451 ??         0:02.88 /System/Library/PrivateFrameworks/CoreParsec.framework/parsecd
15460 ??         0:02.48 /System/Library/PrivateFrameworks/GeoServices.framework/geod
19001 ??         0:41.82 /System/Library/PrivateFrameworks/MobileContainerManager.framework/Support/containermanagerd
19007 ??         0:11.98 /System/Library/PrivateFrameworks/AuthKit.framework/akd
19013 ??         0:01.89 /usr/libexec/adid
20825 ??         0:02.16 /usr/libexec/pkd
21158 ??         0:26.20 /usr/libexec/mobileassetd
21179 ??         0:01.93 /System/Library/PrivateFrameworks/CoreSuggestions.framework/suggestd
22153 ??         1:05.72 /System/Library/PrivateFrameworks/AggregateDictionary.framework/Support/aggregated
22795 ??         0:07.83 /System/Library/PrivateFrameworks/AssistantServices.framework/assistant_service
22818 ??         0:03.37 /System/Library/PrivateFrameworks/CalendarDaemon.framework/Support/calaccessd
23001 ??         0:00.01 /usr/libexec/rocketd
23003 ??         0:00.02 /usr/local/bin/dropbear -F -R -p 127.0.0.1:22
23061 ??         0:03.90 /System/Library/PrivateFrameworks/Search.framework/searchd
23145 ??         0:00.79 /usr/libexec/mobileactivationd
23157 ??         0:00.30 /System/Library/CoreServices/EscrowSecurityAlert.app/EscrowSecurityAlert
23161 ??         0:00.08 /usr/libexec/online-auth-agent
23164 ??         0:00.92 /System/Library/PrivateFrameworks/PassKitCore.framework/passd
23166 ??         0:00.96 /System/Library/PrivateFrameworks/CacheDelete.framework/deleted
23168 ??         0:01.18 /System/Library/PrivateFrameworks/MusicLibrary.framework/Support/medialibraryd
23175 ??         0:00.09 /usr/libexec/OTATaskingAgent server-init
23178 ??         0:01.95 /System/Library/CoreServices/CacheDeleteDaily
23180 ??         0:00.28 /usr/bin/sysdiagnose
23185 ??         0:00.18 /System/Library/PrivateFrameworks/GenerationalStorage.framework/revisiond
23187 ??         0:00.38 /System/Library/PrivateFrameworks/QuickLookThumbnailing.framework/Support/com.apple.quicklook.ThumbnailsAgent
23189 ??         0:07.65 /System/Library/Frameworks/AssetsLibrary.framework/Support/assetsd
23191 ??         0:00.19 /usr/libexec/replayd
23193 ??         0:00.09 /System/Library/PrivateFrameworks/CoreSymbolication.framework/coresymbolicationd
23195 ??         0:00.65 /System/Library/PrivateFrameworks/Pasteboard.framework/Support/pasted
23205 ??         0:00.85 /System/Library/PrivateFrameworks/CloudServices.framework/XPCServices/com.apple.sbd.xpc/com.apple.sbd
23208 ??         0:11.63 /usr/libexec/gamed
23211 ??         0:00.06 /System/Library/PrivateFrameworks/CloudDocsDaemon.framework/XPCServices/ContainerMetadataExtractor.xpc/ContainerMetadataExtractor
23214 ??         0:00.53 /usr/libexec/webbookmarksd
23216 ??         0:00.22 aslmanager
23219 ??         0:00.27 /System/Library/CoreServices/CacheDeleteITunesStore
23221 ??         0:02.55 /System/Library/CoreServices/CacheDeleteAppContainerCaches
23295 ??         0:00.06 /usr/sbin/absd
23304 ??         0:00.76 /usr/libexec/mmaintenanced
23312 ??         0:00.21 /usr/libexec/diagnosticd
23333 ??         0:00.03 /usr/libexec/misagent
23336 ??         0:00.21 /System/Library/PrivateFrameworks/IMDPersistence.framework/XPCServices/IMDPersistenceAgent.xpc/IMDPersistenceAgent
23421 ??         0:00.08 /usr/libexec/MobileGestaltHelper
23424 ??         0:00.46 /usr/libexec/ptpd -t usb
23430 ??         0:00.04 /usr/libexec/mobile_assertion_agent
23436 ??         0:34.01 /usr/libexec/installd
23437 ??         0:00.00 (MSUnrestrictProc)
23439 ??         0:00.95 /System/Library/PrivateFrameworks/MobileInstallation.framework/XPCServices/com.apple.MobileInstallationHelperService.xpc/com.apple.Mobi
23444 ??         0:01.00 /usr/libexec/mobile_installation_proxy
23450 ??         0:00.27 /usr/libexec/pipelined
23454 ??         0:00.37 /System/Library/PrivateFrameworks/MapsSupport.framework/mapspushd
23463 ??         0:00.15 /Applications/Contacts.app/PlugIns/ContactsCoreSpotlightExtension.appex/ContactsCoreSpotlightExtension
23466 ??         0:00.18 /System/Library/PrivateFrameworks/MediaRemote.framework/Support/mediaremoted
23481 ??         0:00.03 /usr/libexec/afc2d -S -L -d /
23841 ??         0:00.08 /usr/libexec/misd
23844 ??         0:00.02 /usr/libexec/pfd
23871 ??         0:00.27 /System/Library/PrivateFrameworks/VisualVoicemail.framework/vmd
23874 ??         0:03.14 /System/Library/PrivateFrameworks/SoftwareUpdateServices.framework/Support/softwareupdateservicesd
24701 ??         0:17.31 /System/Library/CoreServices/SpringBoard.app/SpringBoard
24703 ??         0:28.49 /usr/libexec/backboardd
24740 ??         0:00.07 /System/Library/PrivateFrameworks/UIFoundation.framework/XPCServices/com.apple.uifoundation-bundle-helper.xpc/com.apple.uifoundation-bu
24830 ??         0:00.93 /System/Library/PrivateFrameworks/AssistantServices.framework/XPCServices/com.apple.siri.ClientFlow.ClientScripter.xpc/com.apple.siri.C
24878 ??         0:00.87 /System/Library/PrivateFrameworks/NanoTimeKitCompanion.framework/nanotimekitcompaniond
24905 ??         0:01.82 /System/Library/PrivateFrameworks/Accessibility.framework/Frameworks/AccessibilityUI.framework/XPCServices/com.apple.accessibility.Acce
25826 ??         0:09.35 /Applications/Cydia.app/Cydia
26128 ??         0:28.02 /var/containers/Bundle/Application/50D7ECBF-5F64-44A7-940F-22D884E16BE8/iQiYiPhoneVideo.app/iQiYiPhoneVideo
26130 ??         0:00.38 /System/Library/Frameworks/WebKit.framework/XPCServices/com.apple.WebKit.Networking.xpc/com.apple.WebKit.Networking
26132 ??         0:00.70 /System/Library/Frameworks/WebKit.framework/XPCServices/com.apple.WebKit.WebContent.xpc/com.apple.WebKit.WebContent
26139 ??         0:00.50 /System/Library/PrivateFrameworks/MobileBackup.framework/backupd
26144 ??         0:00.17 /usr/local/bin/dropbear -F -R -p 127.0.0.1:22
26145 ttys000    0:00.04 -sh
26148 ttys000    0:00.01 ps -A
```

调用**ps -A**查看手机上运行的所有进程，一般我们最近打开的应用都在最后面，我们看后面几条，就找到一条这个

```csharp
26128 ??         0:28.02 /var/containers/Bundle/Application/50D7ECBF-5F64-44A7-940F-22D884E16BE8/iQiYiPhoneVideo.app/iQiYiPhoneVideo
```

###### 步骤三 我们拿到iQiYiPhoneVideo这个名称开始进入调试

```bash
applede-iPhone:~ root# cycript -p iQiYiPhoneVideo
cy#
```

###### 步骤四 打印一下爱奇艺应用的基本信息，我们接着输入，我们打印爱奇艺的bundle id ,和appName

```css
cy# [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"]
@"com.qiyi.iphone"
cy#  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
@"\xe7\x88\xb1\xe5\xa5\x87\xe8\x89\xba"
cy#  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
```

名字打出来的是字节类型了，我们用python转化打印一下

```ruby
xmldeMacBook-Pro:~ xml$ python
Python 2.7.10 (default, Aug 17 2018, 17:41:52)
[GCC 4.2.1 Compatible Apple LLVM 10.0.0 (clang-1000.0.42)] on darwin
Type "help", "copyright", "credits" or "license" for more information.
>>> print '\xe7\x88\xb1\xe5\xa5\x87\xe8\x89\xba'
爱奇艺
>>>
```

> 我们今后调试应用的时候基本就是这个流程，先找到你要调试的app的进程，然后开启Cycript,最后开始调试，你发现我们输入的OC语法基本都支持，就跟我们平时开发一样，下面我们了解一下Cycript的一些基本语法

###### 2.2 Cycript基本语法

**注意：**调试的过程中调试的app一定是在打开前台状态，手机也不能熄屏，否者调试会卡住。
1 常量语法,UIApp

```objectivec
cy# UIApp
#"<UIApplication: 0x106b693e0>"
cy# UIApp.key
keyCommands  keyWindow
cy# UIApp.keyWindow
#"<UIWindow: 0x106b87880>Frame: (0.000000, 0.000000, 320.000000, 568.000000)\ttag:0"
cy# UIApp.keyWindow.rootViewController
#"<RootViewController: 0x1070d7400>"
cy#
```

2 定义变量 var 变量名 = 变量值

```objectivec
cy# var rootController = UIApp.keyWindow.rootViewController
#"<RootViewController: 0x1070d7400>"
cy# rootController.view
#"<UIView: 0x10672d380>Frame: (0.000000, 0.000000, 320.000000, 568.000000)\ttag:0"
cy#
```

3 用内存地址获取对象，#+内存地址

```css
cy# #0x10672d380
#"<UIView: 0x10672d380>Frame: (0.000000, 0.000000, 320.000000, 568.000000)\ttag:0"
```

4 查看已加载所有OC类 ObjectiveC.classes

```csharp
cy# ObjectiveC.classes
//打印的东西太多了，就不贴出来了
```

5 查看对象的所有成员变量 *+对象

```tsx
cy# *UIApp
{isa:UIApplication,_hasOverrideClient:false,_hasOverrideHost:false,_hasInputAssistantItem:false,_delegate:#"<AppDelegate: 0x11fd2e1d0>",_exclusiveTouchWindows:[NSSet setWithArray:@[]]],_event:#"<UIEvent: 0x17402c0e0>",_motionEvent:#"<UIMotionEvent: 0x1741663c0> timestamp: 0 subtype: 0",_remoteControlEvent:#"<UIRemoteControlEvent: 0x1700541f0>",_remoteControlEventObservers:0,_topLevelNibObjects:null,_networkResourcesCurrentlyLoadingCount:0,_hideNetworkActivityIndicatorTimer:null,_editAlertView:null,_statusBar:#"<UIStatusBar: 0x120842a00>Frame: (0.000000, 0.000000, 320.000000, 20.000000)\ttag:0",_statusBarRequestedStyle:1,_statusBarWindow:#"<UIStatusBarWindow: 0x11fd2eec0>Frame: (0.000000, 0.000000, 320.000000, 568.000000)\ttag:0",_observerBlocks:@[],_postCommitActions:@[],_postCommitActionsNeedToSynchronize:false,_mainStoryboardName:null,_tintViewDurationStack:null,_statusBarTintColorLockingControllers:null,_statusBarTintColorLockingCount:0,_idleModeController:null,_displayLayoutMonitor:null,_normativeWhitePointAdaptivityStyle:0,_eventFetcher:#"<UIEventFetcher: 0x1700c2ed0>",_eventDispatcher:#"<UIEventDispatcher: 0x170054220>",_applicationFlags:@error,_defaultTopNavBarTintColor:null,_undoButtonIndex:0,_redoButtonIndex:0,_moveEvent:#"<UIMoveEvent: 0x170054040>",_physicalKeyCommandMap:@{},_physicalKeycodeMap:[NSOrderedSet orderedSetWithArray:@[]]],_alwaysHitTestsForMainScreen:false,_backgroundHitTestWindow:null,_classicMode:0,_ignoredStyleOverrides:0,_externalDeactivationReasons:0,_actionsPendingInitialization:null,_idleTimerDisabledReasons:@error,_keyRepeatAction:null,_currentTimestampWhenFirstTouchCameDown:0,_currentLocationWhereFirstTouchCameDown:{x:0,y:0},_sceneSettingsPreLifecycleEventDiffInspector:#"<UIApplicationSceneSettingsDiffInspector: 0x17402d640> {\n    observerInfo = <BSMutableSettings: 0x17402c8a0> { };\n    otherSettingsObserverInfo = <BSMutableSettings: 0x17402cf00> {\n        (3) = (\n    \"<__NSMallocBlock__: 0x174057f10>\"\n);\n    };\n}",_sceneSettingsPostLifecycleEventDiffInspector:#"<UIApplicationSceneSettingsDiffInspector: 0x17402cf80> {\n    observerInfo = <BSMutableSettings: 0x17402d2e0> { };\n    otherSettingsObserverInfo = <BSMutableSettings: 0x17402cfa0> {\n        (2) = (\n    \"<__NSMallocBlock__: 0x174058000>\"\n);\n        (3) = (\n    \"<__NSMallocBlock__: 0x174058090>\"\n);\n        (4) = (\n    \"<__NSMallocBlock__: 0x174058240>\"\n);\n        (5) = (\n    \"<__NSMallocBlock__: 0x174058120>\"\n);\n        (7) = (\n    \"<__NSMallocBlock__: 0x174058360>\"\n);\n        (8) = (\n    \"<__NSMallocBlock__: 0x1740582d0>\"\n);\n        (10) = (\n    \"<__NSMallocBlock__: 0x1740581b0>\"\n);\n    };\n}",_sceneSettingsGeometryMutationDiffInspector:#"<UIApplicationSceneSettingsDiffInspector: 0x17402cf20> {\n    observerInfo = <BSMutableSettings: 0x17402c880> {\n        (2) = (\n    \"<__NSGlobalBlock__: 0x1b29935e0>\"\n);\n        (4) = (\n    \"<__NSGlobalBlock__: 0x1b2993620>\"\n);\n    };\n    otherSettingsObserverInfo = <BSMutableSettings: 0x17402c7c0> { };\n}",_saveStateRestorationArchiveWithFileProtectionCompleteUntilFirstUserAuthentication:false,_fenceTaskAssertion:null,_cachedSystemAnimationFence:null,_systemNavigationAction:null,_activityContinuationManager:#"<UIActivityContinuationManager: 0x170056e90>",__gestureEnvironment:#"<UIGestureEnvironment: 0x1700c1500>",_forceStageObservable:null,_HIDGameControllerEventObserver:null,_HIDGameControllerEventQueue:null,_motionEventBehavior:null,optOutOfRTL:false,_isDisplayingActivityContinuationUI:false,_lastTimestampWhenFirstTouchCameDown:0,_lastTimestampWhenAllTouchesLifted:0,_virtualHorizontalSizeClass:0,_virtualVerticalSizeClass:0,_shortcutService:null,___queuedOrientationChange:null,__expectedViewOrientation:1,_lastLocationWhereFirstTouchCameDown:{x:0,y:0},_lastLocationWhereAllTouchesLifted:{x:0,y:0},_virtualWindowSizeInSceneReferenceSpace:{width:320,height:568}}
cy#
```

6 递归打印view的所有子控件
** 注意这里的对象只能是view或其子对象，其他对象报错**

```xml
cy# rootController.view.recursiveDescription().toString()
`<UIView: 0x106c6fdd0>Frame: (0.000000, 0.000000, 320.000000, 568.000000)\ttag:0
   | <UIView: 0x11ac308b0>Frame: (0.000000, 0.000000, 320.000000, 568.000000)\ttag:0
   |    | <NotesView: 0x11ab2ea30>Frame: (0.000000, 64.000000, 320.000000, 504.000000)\ttag:0
   |    |    | <SPActivityIndicatorView: 0x11ab2cd20>Frame: (150.000000, 306.000000, 20.000000, 20.000000)\ttag:0
   |    |    |    | <UIView: 0x11ab2ec40>Frame: (0.000000, 0.000000, 20.000000, 20.000000)\ttag:0
   |    |    |    |    | <CAShapeLayer: 0x1746216c0> (layer)
   |    |    |    |    |    | <CAShapeLayer: 0x1746216e0> (layer)
   |    |    |    |    |    |    | <CAShapeLayer: 0x174621840> (layer)
   |    |    |    |    |    |    | <CAShapeLayer: 0x174621860> (layer)
   |    |    |    |    | <CAShapeLayer: 0x174621700> (layer)
   |    |    |    |    | <CAShapeLayer: 0x1746217a0> (layer)
   |    |    | <UILabel: 0x11ab2ca90>Frame: (20.000000, 231.000000, 320.000000, 20.000000)\ttag:0
   |    |    |    | <_UILabelContentLayer: 0x170631c40> (layer)
   |    |    | <UIButton: 0x11ab2c170>Frame: (26.000000, 261.000000, 120.500000, 40.500000)\ttag:0
   |    | <UIView: 0x11ac36580>Frame: (0.000000, 0.000000, 320.000000, 568.000000)\ttag:0
```

7 筛选出某种类型的对象 choose(object)

```csharp
cy# choose(UIViewController)
[#"<QYPlayRecordMessageController: 0x11e037960>",#"<QRFeedBackViewController: 0x11e068e50>",#"<QRFeedBackViewController: 0x11e06a1a0>",#"<QYPhonePlayerController: 0x118d7eb80>",#"<QYRecomChannelHomeViewController: 0x10785b800>",#"<RootViewController: 0x1078b9800>",#"<QYRecomChannelViewControllerV3: 0x10718fa00>",#"<QYPlayerViewController: 0x107276200>"]
cy#
```

一般常用语法就这么对，够用了，开发中一句一句敲代码还是挺麻烦的，如果我们要执行多行代码的就麻烦了，就得使用函数了，但是在命令行里敲还是麻烦，如果我们把常用的功能封装成一个工具类，到时候直接用就很方便了，下面我们看怎么封装一个Cycript脚本。

##### 三 封装Cycript脚本

###### 步骤一 新建一个.py文件



![img](https://upload-images.jianshu.io/upload_images/1972799-471bb684bcd54b06.png?imageMogr2/auto-orient/strip|imageView2/2/w/308/format/webp)

cycripttest.py

###### 步骤二 随便找个编辑器进行编辑

```jsx
(function(exports) {

    // app id
    AppId = [NSBundle mainBundle].bundleIdentifier;

    // mainBundlePath
    AppPath = [NSBundle mainBundle].bundlePath;

    // keyWindow
    KeyWid = function() {
        return UIApp.keyWindow;
    };

    // 根控制器
    RootVc =  function() {
        return UIApp.keyWindow.rootViewController;
    };

})(exports);
```

###### 步骤三 将文件放到iphone/Device/usr/lib/cycript9.0/



![img](https://upload-images.jianshu.io/upload_images/1972799-ed7433037961a110.png?imageMogr2/auto-orient/strip|imageView2/2/w/825/format/webp)

通过ifunbox直接拖到iPhone相应文件目录下即可

###### 步骤四 如何使用

```php
applede-iPhone:~ root# cycript -p iQiYiPhoneVideo
cy# @import cycripttest
{}
cy# AppId
@"com.qiyi.iphone"
cy# AppPath
@"/var/containers/Bundle/Application/50D7ECBF-5F64-44A7-940F-22D884E16BE8/iQiYiPhoneVideo.app"
cy#
cy# KeyWid
function (){return UIApp.keyWindow}
cy# KeyWid()
#"<UIWindow: 0x143d41390>Frame: (0.000000, 0.000000, 320.000000, 568.000000)\ttag:0"
cy#
```

以上就是脚本的编写和使用过程，今后你直接将你需要的功能放到这个脚本里面就好了，如果你正在调试一个app，如果脚本变动了，需要退出app，重新进入调试，为了防止冲突，这个脚本你也可以放到cycript9.0/你自定义的目录下比如cycript9.0/com/xu/cycripttest.py,但是引入的时候你也需要改变一下 **@import com.xu.cycripttest**

##### 四 Cycript使用示例。

我们用户网易云音乐的界面来练习cycript如何操作输入文本框，以及处理按钮点击等操作。



![img](https://upload-images.jianshu.io/upload_images/1972799-6b69f6bddfed60cb.png?imageMogr2/auto-orient/strip|imageView2/2/w/362/format/webp)

网易云音乐登录页面

###### 1 先定位登录页面

```php
applede-iPhone:~ root# cycript -p neteasemusic
cy# @import mjcript     //这里使用MJ封装的脚本库，网上有的
{}
cy# MJFrontVc
function (){return s(UIApp.keyWindow.rootViewController)}
cy# MJFrontVc()
#"<NMPhoneLoginViewController: 0x11a57a050>"
```

我们定位到登录页面是NMPhoneLoginViewController: 0x11a57a050，接下来我们要定位手机号输入框

###### 2 从NMPhoneLoginViewController,view的子view去查找手机号编辑框

```csharp
cy# MJSubviews(#0x11a57a050)
throw new Error("Invalid parameter") /*
    MJSubviews */
cy# MJSubviews(#0x11a57a050.view)
`<NMPhoneLoginView: 0x118b18e50; frame = (0 0; 320 568); gestureRecognizers = <NSArray: 0x170842490>; layer = <CALayer: 0x170234b00>>
   | <UIView: 0x118b25d10; frame = (16 79; 288 86); layer = <CALayer: 0x170233ca0>>
   |    | <FXIconTextField: 0x11c8eef00; baseClass = UITextField; frame = (0 0; 288 43); text = ''; opaque = NO; autoresize = H; tintColor = UIExtendedSRGBColorSpace 0 0 0.00392157 0.5; gestureRecognizers = <NSArray: 0x17464ab60>; layer = <CALayer: 0x170233da0>>
   |    |    | <UIView: 0x103fb05b0; frame = (0 42; 288 0.5); userInteractionEnabled = NO; layer = <CALayer: 0x170233a20>>
   |    |    | <UITextFieldLabel: 0x103fb0750; frame = (31 0; 257 42.5); text = '\u624b\u673a\u53f7'; opaque = NO; userInteractionEnabled = NO; layer = <_UILabelLayer: 0x170880f50>>
   |    |    |    | <_UILabelContentLayer: 0x170633520> (layer)
   |    |    | <UIFieldEditor: 0x104bbc000; frame = (31 0; 257 43); text = ''; clipsToBounds = YES; opaque = NO; gestureRecognizers = <NSArray: 0x170645400>; layer = <CALayer: 0x170232940>; contentOffset: {0, 0}; contentSize: {257, 43}>
   |    |    |    | <_UIFieldEditorContentView: 0x118b25060; frame = (0 0; 257 43); opaque = NO; userInteractionEnabled = NO; layer = <CALayer: 0x170827380>>
   |    |    |    |    | <UITextSelectionView: 0x11a5bc270; frame = (0 0; 0 0); userInteractionEnabled = NO; layer = <CALayer: 0x17423c240>>
   |    |    |    |    |    | <UIView: 0x118b37270; frame = (0 10; 2 22); alpha = 0; userInteractionEnabled = NO; animations = { opacity=<CABasicAnimation: 0x17022cca0>; }; layer = <CALayer: 0x170827b20>>
   |    |    | <UIView: 0x118b35990; frame = (0 -1; 31 45); layer = <CALayer: 0x170233dc0>>
   |    |    |    | <UIImageView: 0x118b1f790; frame = (2 12.5; 20 20); opaque = NO; userInteractionEnabled = NO; layer = <CALayer: 0x170233d80>>
   |    | <FXIconTextField: 0x103fb09e0; baseClass = UITextField; frame = (0 43; 288 43); text = ''; opaque = NO; tintColor = UIExtendedSRGBColorSpace 0 0 0.00392157 0.5; gestureRecognizers = <NSArray: 0x174853b90>; layer = <CALayer: 0x170233760>>
   |    |    | <UIView: 0x103faa5a0; frame = (0 42; 288 0.5); userInteractionEnabled = NO; layer = <CALayer: 0x170233440>>
   |    |    | <UIView: 0x103fafd10; frame = (0 -1; 31 45); layer = <CALayer: 0x170233520>>
   |    |    |    | <UIImageView: 0x103fafeb0; frame = (2 12.5; 20 20); opaque = NO; userInteractionEnabled = NO; layer = <CALayer: 0x170233500>>
   |    |    | <UITextFieldLabel: 0x103faa740; frame = (31 0; 257 42.5); text = '\u5bc6\u7801'; opaque = NO; userInteractionEnabled = NO; layer = <_UILabelLayer: 0x17029ae50>>
   |    |    |    | <_UILabelContentLayer: 0x17423bea0> (layer)
   | <UIButton: 0x103fa8710; frame = (16 195; 288 40); clipsToBounds = YES; opaque = NO; layer = <CALayer: 0x1702331c0>>
   |    | <UIImageView: 0x104290520; frame = (0 0; 288 40); clipsToBounds = YES; opaque = NO; userInteractionEnabled = NO; layer = <CALayer: 0x17423c340>>
   |    | <UIButtonLabel: 0x118b18300; frame = (126.5 10; 35 20.5); text = '\u767b\u5f55'; opaque = NO; userInteractionEnabled = NO; layer = <_UILabelLayer: 0x17029ab30>>
   |    |    | <_UILabelContentLayer: 0x17423c180> (layer)
   | <NMPasswordButton: 0x103fa89d0; baseClass = UIButton; frame = (125 255; 70 25); opaque = NO; layer = <CALayer: 0x170233020>>
   |    | <UIButtonLabel: 0x103fa8ca0; frame = (6.5 4; 57.5 17); text = '\u91cd\u8bbe\u5bc6\u7801'; opaque = NO; userInteractionEnabled = NO; layer = <_UILabelLayer: 0x17029a8b0>>
   |    |    | <_UILabelContentLayer: 0x17423c320> (layer)
   |    | <UIView: 0x103f4a460; frame = (6 23; 58 1); layer = <CALayer: 0x17022f1c0>>`
cy#
```

我们看到有这么一行



![img](https://upload-images.jianshu.io/upload_images/1972799-f28260cc4a43eb83.png?imageMogr2/auto-orient/strip|imageView2/2/w/1040/format/webp)

那么这个

\u624b\u673a\u53f7

是什么，我们用python打印一下看看



```python
xmldeMacBook-Pro:~ xml$ python
Python 2.7.10 (default, Aug 17 2018, 17:41:52)
[GCC 4.2.1 Compatible Apple LLVM 10.0.0 (clang-1000.0.42)] on darwin
Type "help", "copyright", "credits" or "license" for more information.
>>> print u'\u624b\u673a\u53f7'
手机号
>>>
```

我们看到就是手机号，**UITextFieldLabel: 0x103fb0750**，就是它的对象，我们仔细看这个对象的父控件是**FXIconTextField: 0x11c8eef00**;从名称上看这是是一个自定义的带有图标的文本编辑框
那我们输入文本试一下

```objectivec
cy# #0x11c8eef00.text = "15856885688"
"15856885688"
```





![img](https://upload-images.jianshu.io/upload_images/1972799-e1da330cd00d1973.png?imageMogr2/auto-orient/strip|imageView2/2/w/302/format/webp)

输入命令回车，我们就发现手机界面立马就填上了手机号，那说明我们找的这个控件（

FXIconTextField: 0x11c8eef00

）就是编辑框了，

同理我们找出密码框，界面上他们是挨着的，我们通过打印的信息就能看到，下面也有一个

FXIconTextField: 0x103fb09e0



![img](https://upload-images.jianshu.io/upload_images/1972799-99cd53d12ffed1f8.png?imageMogr2/auto-orient/strip|imageView2/2/w/711/format/webp)

这回我们不看里面子控件有没有密码lable,我们直接输文本看看界面有没有变化



```objectivec
cy# #0x103fb09e0.text = "123456"
"123456"
```





![img](https://upload-images.jianshu.io/upload_images/1972799-48f4a0e1650647b1.png?imageMogr2/auto-orient/strip|imageView2/2/w/300/format/webp)

界面立马反应了，密码输入框变化了，那这里我们就找到了密码输入控件

FXIconTextField: 0x103fb09e0



###### 3 按钮登录

这里我们要找到按钮控件，然后触发它的点击事件，从界面上看登录按钮在密码框下面，我们在打印信息里往下看就行了，



![img](https://upload-images.jianshu.io/upload_images/1972799-302ef0dcbb9d0281.png?imageMogr2/auto-orient/strip|imageView2/2/w/882/format/webp)

靠猜测我们基本能判定**UIButton: 0x103fa8710**就是登录按钮，**NMPasswordButton: 0x103fa89d0**这个是找回密码按钮。接下来验证我们的猜测，我们触发按钮的点击事件。

```bash
cy# [#0x103fa8710  sendActionsForControlEvents:UIControlEventTouchUpInside]
```



![img](https://upload-images.jianshu.io/upload_images/1972799-f3a237e950a073a1.png?imageMogr2/auto-orient/strip|imageView2/2/w/299/format/webp)

我们看到界面上就有反应了，到此这三个控件就找到了，本节我们就演示了用过cycript定位控件。
总结：有些时候我们在查找控件大部分都是根据我们的经验去猜测判断，所以丰富的iOS开发经验，在逆向工程中是有很大帮助的。首先我们要根据UI页面结构，去猜测它的控件构成，然后一步步的去验证我们的猜想。最后我们再总结下定位界面元素有哪些步骤
1 找到当前页面的主控制器
2 打印控制器所有的子控件
3 根据UI结构和打印的子控件结构，去分析可能是哪个控件，( 有文本的情况下会乱码，我们用python,就能还原中文)
4 猜测是哪个控件，然后想办法去验证，改变文本，触发事件等等，然后看UI界面变化，有时候我们没找对的话，需要反复操作3，4步骤，直到找到为止。
当然了这只是cycript一个应用示例，其他使用还有带我们实际开发过程中，去总结，去探索。