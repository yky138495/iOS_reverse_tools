# 三 远程登录(OpenSSH)/USB登录到手机

0.272019.02.19 23:12:43字数 1486阅读 438

- 如何通过OpenSSH远程登录到手机
- 如何通过USB登录到手机
- OpenSSH通信原理与USB登录本质

> 我们经常在Mac的终端上，通过敲一些命令来完成一些操作，iOS和Max OS X都是基于Darwin(苹果的一个基于Unix的开源系统内核)所以iOS中同样支持终端的命令操作，在逆向工程中，我们经常会通过命令来操纵iPhone，为了能够让Mac终端命令行能够作用在iPhone上，我们需要Mac和iPhone建立连接，接下来我们看一下如何去建立连接。

##### 一 如何通过OpenSSH远程登录到手机

###### 步骤一 安装OpenSSH

通过Cydia搜索OpenSSH,然后点击安装(Cydia作者Jay Freeman 写的一个工具)。



![img](https://upload-images.jianshu.io/upload_images/1972799-ec094b68dd085307.png?imageMogr2/auto-orient/strip|imageView2/2/w/293/format/webp)

安装OpenSSH

###### 步骤二 打开Mac上的终端输入：

```css
ssh root@192.168.1.5
```

192.168.1.5是你手机IP地址，注意你的iPhone要和Mac在同一个局域网内。

###### 输入密码 :alpine





初始密码是固定的



![img](https://upload-images.jianshu.io/upload_images/1972799-51e6db51c2e0bbf0.png?imageMogr2/auto-orient/strip|imageView2/2/w/411/format/webp)

###### 登录到手机上来了

看applede-iPhone,就带表登录到手机上了



![img](https://upload-images.jianshu.io/upload_images/1972799-da8c6a257954d4cd.png?imageMogr2/auto-orient/strip|imageView2/2/w/317/format/webp)

登录到手机

OK OpenSSH就这简单的三步骤，有些时候，可能会遇到一些问题

```css
ssh: connect to host 192.168.1.5 port 22: Connection refused
```

出现这个问题去网上搜索吧，我遇到的问题是一值卡在那不动，好长时间返回time out,[网上搜说](https://bbs.feng.com/read-htm-tid-11012836.html)iOS10.0以上本地自带USB连接，不需要Wi-Fi连接，我的机器是iOS10.2，用USB连接是好的。这个Wi-Fi连接不上还是不知道具体原因。

##### 二 如何通过USB登录到手机

因为通过Wi-Fi登录iPhone网络不好的情况下，输入一些终端命令会比较卡，逆向中我们经常用的是USB登录到远程手机，下面我们来了解下该怎么做

###### 步骤一 下载usbmuxd工具包

usbmuxd下载地址：<https://cgit.sukimashita.com/usbmuxd.git/snapshot/usbmuxd-1.0.8.tar.gz>

###### 步骤二 端口映射

将iPhone的22端口映射到Mac本地的10001(只要不是常用端口，这个可以随便写)端口

```ruby
xmldeMacBook-Pro:~ xml$ cd /Users/xml/Downloads/usbmuxd-1.0.8\ 2/python-client/
xmldeMacBook-Pro:python-client xml$ python tcprelay.py -t 22:10001
```



![img](https://upload-images.jianshu.io/upload_images/1972799-658c1b07eddac611.png?imageMogr2/auto-orient/strip|imageView2/2/w/576/format/webp)

进入到tcprelay.py文件夹下，执行python命令

###### 步骤三 登录到手机

```ruby
xmldeMacBook-Pro:~ xml$ ssh root@localhost -p 10001
```



![img](https://upload-images.jianshu.io/upload_images/1972799-228af89e7c09c97a.png?imageMogr2/auto-orient/strip|imageView2/2/w/623/format/webp)

按提示输入密码，就登录成功了

> 到此USB登录就这简单的三部，以后每次我们登录手机，只要执行后两部就可以了。因为命令比较长，又经常用，我们可以封装成一个简单的脚本，方便使用。
> 1 新建一个usbconnect.sh文件，文件内容就是python-client xml$ python tcprelay.py -t 22:10001
> 2 新建一个 sshlogin.sh, 文件内容就是步骤三的命令。
> 3 把这两个文件放到用户根目录下
> 4 每次登录你先执行 **sh usbconnect.sh**,在执行是**sh sshlogin.sh**就可以了

好了，如果你是急于上手开发，那么了解上面的内容就已经足够了，如果还想进一步了解它们的原理细节，那么就请接着往下看。

##### 三 OpenSSH通信原理与USB登录本质

###### 3.1什么是SSH，OpenSSH，SSL，OpenSSL？

1 SSH Secure Shell的缩写，意为“安全外壳协议”，是一种可以为远程登录提供安全保障的协议，使用SSH，可以把所有传输的数据进行加密，"中间人攻击“的方式就不可能实现，能防止DNS欺骗和IP欺骗
2 OpenSSH是SSH协议的免费开源实现，可以通过OpenSSH的方式让Mac远程登录到iPhone
3 SSL Secure Sockets Layer的缩写，是为网络提供安全及数据完整性的一种安全协议，在传输层对网络连接进行加密
4 OpenSSH SSL的开源实现，绝大部分HTTPS请求等价于:HTTP+OpenSSL,OpenSSH的加密就是通过OpenSSL完成的。
3.2 SSH的版本
SSH协议一共有两个版本：SSH-1,SSH-2,现在用的比较多的是SSH-2,客户端和服务端本要保持一致才能通信，

###### 查看Mac端SSH版本

```bash
xmldeMacBook-Pro:~ xml$ cd /etc/ssh
```



![img](https://upload-images.jianshu.io/upload_images/1972799-e4fae5336ad3b81b.png?imageMogr2/auto-orient/strip|imageView2/2/w/417/format/webp)

ls 查看下面的文件

```ruby
xmldeMacBook-Pro:ssh xml$ cat ssh_config
```



![img](https://upload-images.jianshu.io/upload_images/1972799-f3db571789013396.png?imageMogr2/auto-orient/strip|imageView2/2/w/401/format/webp)

Prorocol 2 就代表是版本2

###### 查看iPhone手机端SSH版本

```bash
applede-iPhone:~ root# cd /etc/ssh
applede-iPhone:/etc/ssh root# ls
moduli  ssh_config  sshd_config
applede-iPhone:/etc/ssh root# cat ssh_config
```



![img](https://upload-images.jianshu.io/upload_images/1972799-0dc6337d9369e6b7.png?imageMogr2/auto-orient/strip|imageView2/2/w/272/format/webp)

两个版本都有

###### 3.3 SSH 通信的过程

分为三步

###### 1 建立安全连接

在建立安全连接过程中，服务器会提供自己的身份证明



![img](https://upload-images.jianshu.io/upload_images/1972799-de0a6b2374855aee.png?imageMogr2/auto-orient/strip|imageView2/2/w/903/format/webp)

服务端把公钥，发送给客户端，第一次连接，会提示是否要保存认证信息，保存在known_hosts文件中，然后客户端每次拿着这个公钥，发送数据到服务器端，服务器，用自己的私钥再进行验证

###### 2 客户端认证

1 密码登录验证

```ruby
xmldeMacBook-Pro:~ xml$ sh login.sh
root@localhost's password:
```

2 基于密钥的客户端认证，它是一种免密认证，是最安全的一种认证方式。SSH-2会先尝试这种方式的认证，如果失败，才会采用第一种密码认证的方式，我们来看看怎么做这个免密认证。
1 客户端(Mac)生成公钥和私钥文件**~/.ssh/id_rsa.pub \** \** ~/.ssh/id_rsa**

```bash
xmldeMacBook-Pro:.ssh xml$ cd ~/.ssh
xmldeMacBook-Pro:.ssh xml$ ssh-keygen
xmldeMacBook-Pro:.ssh xml$ ls -l
total 56
-rw-r--r--@ 1 xml  staff   230  3 10  2018 config
-rw-------  1 xml  staff  1675  2 16 22:38 id_rsa
-rw-r--r--  1 xml  staff   408  2 16 22:38 id_rsa.pub
-rw-------  1 xml  staff  1084  2 16 22:10 known_hosts
-rw-r--r--  1 xml  staff  1255  2 16 15:33 known_hosts.old
-rw-------  1 xml  staff  3326  3 10  2018 lerpo-GitHub
-rw-r--r--  1 xml  staff   775  3 10  2018 lerpo-GitHub.pub
```

2 客户端将公钥内容追加到服务器端(iPhone)授权文件（**~/.ssh/authorized_keys**）的尾部
3 服务器端进行登录认证

```go
mldeMacBook-Pro:.ssh xml$ ssh-copy-id root@localhost -p 10001
/usr/bin/ssh-copy-id: INFO: Source of key(s) to be installed: "/Users/xml/.ssh/id_rsa.pub"
/usr/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed
/usr/bin/ssh-copy-id: INFO: 1 key(s) remain to be installed -- if you are prompted now it is to install the new keys
root@localhost's password:

Number of key(s) added:        1

Now try logging into the machine, with:   "ssh -p '10001' 'root@localhost'"
and check to make sure that only the key(s) you wanted were added.
```

再登录就不需要密码了

```ruby
xmldeMacBook-Pro:~ xml$ ssh root@localhost -p 10001
applede-iPhone:~ root#
```

查看是否加入到了服务器验证文件尾部我们看到下面~/.ssh/authorized_keys与 ~/.ssh/id_rsa.pub内容是一样的

```ruby
xmldeMacBook-Pro:~ xml$ ssh root@localhost -p 10001
applede-iPhone:~ root# cat ~/.ssh/authorized_keys
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQChUWSIe2E7w6t7yLQ2ery10mYHPoLdPbEgjC9X7lVaiIT+7YWMz2E50UoI+kcd+Ctr7ScKsPFiKqR24no4neznv3AHFbTOTsRuP3DE7EkrU33+OPWSOSK/dT8W9HcwAlBkxHOBlMc7fAoTLvAFBcL8nvG5AE0GIRqzLKJ5ZMEcAJPB5Mg0PwmNH6oX2/34BZ0BZeYDmINtgkCunmeXRyhIEhpFY/1GtJmUU1oyVO8bDbOYGmNll6lcjWaqS2ou4U7Obr8k84snfO6cXVZ6xz6mkP8keI7rLiq2x2Bjt40Kvht9km4eNOuvL0qobKhzEM1XQXzudY/5m4B38xr7Fi5p xml@xmldeMacBook-Pro.local
applede-iPhone:~ root# exit
logout
Connection to localhost closed.
xmldeMacBook-Pro:~ xml$ cat ~/.ssh/
config            id_rsa.pub        known_hosts.old   lerpo-GitHub.pub
id_rsa            known_hosts       lerpo-GitHub
xmldeMacBook-Pro:~ xml$ cat ~/.ssh/id_rsa.pub
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQChUWSIe2E7w6t7yLQ2ery10mYHPoLdPbEgjC9X7lVaiIT+7YWMz2E50UoI+kcd+Ctr7ScKsPFiKqR24no4neznv3AHFbTOTsRuP3DE7EkrU33+OPWSOSK/dT8W9HcwAlBkxHOBlMc7fAoTLvAFBcL8nvG5AE0GIRqzLKJ5ZMEcAJPB5Mg0PwmNH6oX2/34BZ0BZeYDmINtgkCunmeXRyhIEhpFY/1GtJmUU1oyVO8bDbOYGmNll6lcjWaqS2ou4U7Obr8k84snfO6cXVZ6xz6mkP8keI7rLiq2x2Bjt40Kvht9km4eNOuvL0qobKhzEM1XQXzudY/5m4B38xr7Fi5p xml@xmldeMacBook-Pro.local
xmldeMacBook-Pro:~ xml$
```

如果上面操作完成后还是需要密码登录可能是权限不足，需要这样操作。

```undefined
chmod 755 ~
chmod 755 ~/.ssh
chmod 644 ~/.ssh/authorized.keys
```

3 数据传输

###### 3.4 usb登录本质

Mac上有个服务程序usbmuxd,可以将mac的数据通过usb传输到iPhone上去



![img](https://upload-images.jianshu.io/upload_images/1972799-8ab334b84e82d67f.png?imageMogr2/auto-orient/strip|imageView2/2/w/765/format/webp)

usbmuxd的存放路径 /System/Library/PrivateFrameworks/MobileDevice.framework/Resources/usbmuxd

首先通过SSH登录到我们本地自定义的一个端口，然后在通过usbmuxd通过usb将数据转发到iPhone 22端口上去，那么如何让SSH登录到我们自定义的端口上呢，那就是通过我们上面讲的usbmuxd工具包,这个python工具，虽然我们数据是通过usb传输的，但是我们还是通过SSH协议来进行的，所以哪些SSH连接验证等操作根Wi-Fi连接方式是一样的。