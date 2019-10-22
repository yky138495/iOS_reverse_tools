# 四 iOS逆向- Mach-O

0.8062019.02.23 20:09:57字数 888阅读 152

- Mach-O文件类型
- Mach-O文件基本结构
- 通用二进制文件

> Mach-O是Mach object的缩写，是Mac\iOS上用于存储程序、库的标准格式

##### 一 Mach-O文件类型

```cpp
#define MH_OBJECT   0x1     /* 目标文件*/
#define MH_EXECUTE  0x2     /* 可执行文件 */
#define MH_FVMLIB   0x3     /* fixed VM shared library file */
#define MH_CORE     0x4     /*核心转储文件 */
#define MH_PRELOAD  0x5     /* preloaded executable file */
#define MH_DYLIB    0x6     /* dynamically bound shared library */
#define MH_DYLINKER 0x7     /* dynamic link editor */
#define MH_BUNDLE   0x8     /* dynamically bound bundle file */
#define MH_DYLIB_STUB   0x9     /* shared library stub for static */
                    /*  linking only, no section contents */
#define MH_DSYM     0xa     /* companion file with only debug */
                    /*  sections */
#define MH_KEXT_BUNDLE  0xb     /* x86_64 kexts */
```

可以在xnu源码中，查看到Mach-O格式的详细定义（<https://opensource.apple.com/tarballs/xnu/>）

- EXTERNAL_HEADERS/mach-o/fat.h

- EXTERNAL_HEADERS/mach-o/loader.h

  

  ![img](https://upload-images.jianshu.io/upload_images/1972799-dfa84ce0e652a4d4.png?imageMogr2/auto-orient/strip|imageView2/2/w/425/format/webp)

  Mach-O格式定义文件所在位置

Mach-O文件的格式还是挺多的，我们简单的了解一下常用的一些类型。

###### 1 MH_OBJECT

- 目标文件（.o）
- 静态库文件(.a），静态库其实就是N个.o合并在一起
  我们常用的目标文件，静态库都是Mach-O格式的

###### 2 MH_EXECUTE：可执行文件

- .app/xx
  app里面的可执行文件也是Mach-O格式的

###### 3 MH_DYLIB：动态库文件

- .dylib
- .framework/xx
  动态库文件也是Mach-O格式的

###### 4 MH_DYLINKER：动态链接编辑器

- /usr/lib/dyld
  [动态链接器](https://www.jianshu.com/p/d225df2f1690)也是Mach-O格式的

###### 5 MH_DSYM：存储着二进制文件符号信息的文件

- .dSYM/Contents/Resources/DWARF/xx（常用于分析APP的崩溃信息）
  我们常用与分析app奔溃信息的符号表文件也是Mach-O格式的。

###### 2 如何查看Mach-O格式的文件

1 使用MachOView工具
下载地址:<https://github.com/gdbinit/MachOView>



![img](https://upload-images.jianshu.io/upload_images/1972799-baa44cd9d22504c4.png?imageMogr2/auto-orient/strip|imageView2/2/w/895/format/webp)



2 otool：查看Mach-O特定部分和段的内容

```bash
xmldeMacBook-Pro:iOS学习 xml$ otool
Usage: /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/otool [-arch arch_type] [-fahlLDtdorSTMRIHGvVcXmqQjCP] [-mcpu=arg] [--version] <object file> ...
    -f print the fat headers
    -a print the archive header
    -h print the mach header
    -l print the load commands
    -L print shared libraries used
    -D print shared library id name
    -t print the text section (disassemble with -v)
    -p <routine name>  start dissassemble from routine name
    -s <segname> <sectname> print contents of section
    -d print the data section
    -o print the Objective-C segment
    -r print the relocation entries
    -S print the table of contents of a library (obsolete)
    -T print the table of contents of a dynamic shared library (obsolete)
    -M print the module table of a dynamic shared library (obsolete)
    -R print the reference table of a dynamic shared library (obsolete)
    -I print the indirect symbol table
    -H print the two-level hints table (obsolete)
    -G print the data in code table
    -v print verbosely (symbolically) when possible
    -V print disassembled operands symbolically
    -c print argument strings of a core file
    -X print no leading addresses or headers
    -m don't use archive(member) syntax
    -B force Thumb disassembly (ARM objects only)
    -q use llvm's disassembler (the default)
    -Q use otool(1)'s disassembler
    -mcpu=arg use `arg' as the cpu for disassembly
    -j print opcode bytes
    -P print the info plist section as strings
    -C print linker optimization hints
    --version print the version of /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/otool
xmldeMacBook-Pro:iOS学习 xml$ otool -h Calculator
Mach header
      magic cputype cpusubtype  caps    filetype ncmds sizeofcmds      flags
 0xfeedfacf 16777228          0  0x00           2    36       5016 0x00200085
```

##### 二 Mach-O文件基本结构



![img](https://upload-images.jianshu.io/upload_images/1972799-4534221c67dc1493.png?imageMogr2/auto-orient/strip|imageView2/2/w/401/format/webp)

Mach-O文件包含3个主要区域

###### 1 Header

文件类型、目标架构类型等

###### 2 Load commands

描述文件在虚拟内存中的逻辑结构、布局

###### 3 Raw segment data

在Load commands中定义的Segment的原始数据



![img](https://upload-images.jianshu.io/upload_images/1972799-bff3cc3cf7bdb074.png?imageMogr2/auto-orient/strip|imageView2/2/w/897/format/webp)

具体文件Mach-O格式展示

具体每一项的含义可参看官方文档:



https://developer.apple.com/library/content/documentation/DeveloperTools/Conceptual/MachOTopics/0-Introduction/introduction.html

了解Mach-O文件的细节，是我们逆向工程的基础，无论是我们用

class_dump

导出头文件，还是使用

hopper disassembler

分析代码实现，都是要用到Mach-O的知识。其实它们都是在根据Mach-O文件的格式，做了图形化的展示。



##### 三 通用二进制文件

mac系统所支持的cpu及硬件平台发生了很大的变化，为了解决软件在多个硬件平台上的兼容性问题，苹果开发了一个通用的二进制文件格式（Universal Binary）,又称胖二进制（Fat Binary）。



我们可以通过file命令来查看这种通用二进制文件：



![img](https://upload-images.jianshu.io/upload_images/1972799-dbcb540122e85f49.png?imageMogr2/auto-orient/strip|imageView2/2/w/351/format/webp)

系统还提供了一个命令行工具lipo来操作通用二进制文件。它可以添加，提取，删除以及替换通用二进制文件中特定架构的二进制文件。
下面我们来探讨一下胖二进制的格式，其头部结构fat_header定义如下：

```cpp
#define FAT_MAGIC    0xcafebabe
#define FAT_CIGAM    0xbebafeca    

struct fat_header {
    uint32_t    magic;        
    uint32_t    nfat_arch;    
};
```

magic字段被定义为常量FAT_MAGIC，表示这是一个胖二进制，nfat_arch表示有多少个Mach-O文件。
每个胖二进制都用fat_arch结构表示，在fat_header之后，紧接着一个或多个连续的fat_arch结构体。

```cpp
struct fat_arch {
    cpu_type_t    cputype;    
    cpu_subtype_t    cpusubtype;   
    uint32_t    offset;        
    uint32_t    size;        
    uint32_t    align;        
};
```

cputype指定了CPU类型，cpusubtype指定了CPU的子类型，offset指定了当前CPU架构数据相对于当前文件开头的偏移值，size字段指明了数据的大小。align字段指明了数据的内存对齐边界，取值必须是2的次方，它确保了当前CPU架构的目标文件在加载到内存中时，数据是经过内存优化对齐的。



1 用otool来查看fat_header信息。



![img](https://upload-images.jianshu.io/upload_images/1972799-bcfe168ab7fb534f.png?imageMogr2/auto-orient/strip|imageView2/2/w/441/format/webp)

2 用lipo来抽取或合并胖二进制文件

- 查看架构信息：lipo -info 文件路径
- 导出某种特定架构：lipo 文件路径 -thin 架构类型 -output 输出文件路径
- 合并多种架构：lipo 文件路径1 文件路径2 -output 输出文件路径
  这个Mach-O比较重要应该属于逆相中基础储备知识，多了解它，我们才能进行后续的工作。