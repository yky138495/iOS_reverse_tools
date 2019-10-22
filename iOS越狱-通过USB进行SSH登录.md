# iOS越狱-通过USB进行SSH登录

0.2222018.10.21 00:09:10字数 528阅读 1001

> 默认情况下，由于SSH走的是TCP协议，Mac是通过网络连接的方式SSH登录到iPhone，要求iPhone连接WiFi
> 为了加快传输速度，也可以通过USB连接的方式进行SSH登录

- **1.数据线接连iPhone**
- **2.下载usbmuxd (https://cgit.sukimashita.com/usbmuxd.git/snapshot/usbmuxd-1.0.8.tar.gz)找到python-client文件下的tcprelay.py文件,cd到文件目录终端执行python 转换端口命令:将iPhone的22端口(SSH端口)映射到Mac本地端口10010端口**

```css
python tcprelay.py -t 22:10010
```

会看到终端输出

```bash
Forwarding local port 10010 to remote port 22
```

- **3.新建一个终端窗口,输入登录指令(注意上面那个Forwarding local port 10010 to remote port 22窗口不要关闭)**

```css
ssh root@localhost -p 10010
```

默认情况,第一次会出现

```bash
The authenticity of host '[localhost]:10010 ([127.0.0.1]:10010)' can't be established.
RSA key fingerprint is SHA256:CnKbWpr/8EFPRUKH/L6vw6sI7YSU9hVhe/nOhWkxD34.
Are you sure you want to continue connecting (yes/no)? 
```

输入`yes`
然后就看到已经登录了

```php
Warning: Permanently added '[localhost]:10010' (RSA) to the list of known hosts.
Administratorde-iPhone:~ root#
```

另外一个转发的终端窗口可以看到输出

```bash
Waiting for devices...
Connecting to device <MuxDevice: ID 160 ProdID 0x12a8 Serial 'bb8ce4295e8db17c6953ff0814d87b231b5e9072' Location 0x14200000>
Connection established, relaying data
```

**1.如果发现**

```undefined
connect to host localhost port 10010: Connection refused
```

说明端口映射没有成功,可能就是你关闭了`Forwarding local port 10010 to remote port 22`终端进程窗口

**2.如果发现**

```bash
Waiting for devices...
No device found
Incoming connection to 10010
```

说明你数据线没有连接,或者数据线连接有问题,重插下数据线,或者换一条数据线

Mac的虚拟网卡的IP地址:127.0.0.1
因此也可以通过以下指令连接服务器

```css
ssh root@127.0.0.1 -p 10010
```

登录指令也可以先写端口号

```css
ssh -p 10010 root@localhost
```

10010是非保留的自己找的端口
端口映射完毕后,以后如果想跟iPhone的22端口通信,直接跟Mac本地的10010端口通信就可以了

## 总结:以后通过USB登录服务器.

1.终端执行python脚本

```css
python tcprelay.py -t 22:10010
```

2.终端执行ssh登录指令

```css
ssh root@localhost -p 10010
```

iPhone默认是使用22端口进行SSH通信,采用的是TCP协议
端口就是设备对外提供服务的窗口,每个端口都有端口号(范围是0~65532,共2^16个)
有些端口是保留的,已经规定了用途,比如
21端口提供FTP服务
80端口提供HTTP服务
22端口提供SSH服务(通过查看/etc/ssh/sshd_config的Port字段来验证)

```bash
#Port 22
```