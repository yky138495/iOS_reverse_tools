命令

## 打印
p $1
po [[UIWindow keyWindow] recursiveDescription]


## 操作内存 
memory write 内存地址 数值
--- memory write 0x7ffee685dba8 25

memory read/数量 _ 格式 _ 字节数 内存地址  / x/数量 _ 格式 _ 字节数 内存地址
```
x ：代表16进制
f ：代表浮点数
d ：代表10进制

b ：byte 代表1个字节
h ：half word 代表2个字节
w ：word 代表4个字节
g ：giant word 代表8个字节

--- memory read/1wx 0x7ffee14a5ba8  ##读取 0x7ffee14a5ba8 中 4 个字节的内容。
--- memory read/1wd 0x7ffee14a5ba8
```

## bt 
bt 返回所有的调用栈

## 内存断点
watchpoint set expression &_name
watchpoint set variable self->_name


## UI 控件查看
```
(lldb) e id $hgView = (id)0x7fdfc66127f0
(lldb) e (void)[$hgView setBackgroundColor:[UIColor redColor]]
(lldb) e (void)[CATransaction flush]
```

## 动态注入代码逻辑


## breakpoint 断点

文件名+行号 breakpoint set -f xxx -l xxx
```
breakpoint set -f ViewController.m -l 30
```

函数名断点
```
方法名断点 breakpoint set -n 方法名
breakpoint set -n viewDidLoad
```

类中方法断点 breakpoint set -n "-[类名 方法名]"
```
breakpoint set -n "-[MobShareViewController viewDidLoad]"
```

 条件断点 breakpoint set -c "xxxx"
 ```
 breakpoint set -f MOBQQViewController.m -l 50 -c "parameters != nil"
```

查看断点列表 breakpoint list
```
breakpoint list
```

禁用/启用断点 breakpoint disable/enable
```
breakpoint disable 2
```

移除断点 breakpoint delete
```
 breakpoint delete 2
```

## 别名
自定义别名 command alias
```
command alias 打印堆栈 thread backtrace

useage：
 打印堆栈 3
```

带参数别名 command alias %1 %2
```
command alias 删除断点 breakpoint delete %1
useage：
删除断点 3
```

##  help

## 汇编调试（Xcode->Debug->Debug workflow->Always Show Disassembly）
查看寄存器
```
register read --all
# 给方法加断点进入断点时x0~x7寄存器存放参数，调用完x0放返回值

# 打印x0寄存器值
register read x0

通过“register write 寄存器名称 数值”格式修改寄存器上的值
```
