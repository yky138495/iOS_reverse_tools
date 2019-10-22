# iOS重签名步骤

12019.03.07 10:11:06字数 292阅读 197

## 一.准备一个embedded.mobileprovision文件(必须是付费证书产生的,appid,device一定要匹配),并放入.app包中

- 1.可以通过Xcode自动生成(随便新建一个iOS项目,注意bundleId 不要包括中划线-否则签名失败),然后再编译后的App包中找到(注意要选择付费team)
- 2.可以去开发者证书网站生成下载(一般可选development)

## 二.从embedded.mobileprovision文件中提取出entitlements.plist权限文件

使用终端指令

```swift
security cms -D -i embedded.mobileprovision > temp.plist
/usr/libexec/PlistBuddy -x -c 'Print:Entitlements' temp.plist > entitlements.plist
```

## 三.查找iOS可用重新签名的证书id(需mac上有可用的付费证书)

```swift
security find-identity -v -p codesigning
```

## 四.对.app内部的动态库,AppExtension等进行签名

```swift
codesign -fs 证书ID xxx.dylib
```

## 五.对.app包进行签名

```swift
codesign -fs 证书ID --entitlements entitlements.plist xxx.app
```

# 重签名GUI工具

### 1.iOS App Signer

<https://github.com/DanTheMan827/ios-app-signer>
可以对.app重签名打包成ipa
需要在.app包中提供对应的embedded.mobileprovision文件

### 2.iReSign

<https://github.com/maciekish/iReSign>
可以对ipa进行重签名
需要提供entitlements.plist ,embedded.mobileprovision文件

**注意**:安装包的可执行文件必须是**脱壳的**,重新签名才会有效,否则即使安装到未越狱设备,启动就会闪退