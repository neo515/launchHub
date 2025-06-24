## THIS IS JUST FOR MAC ！！！
base on macos 15.5

### 说明
不知从哪个新版本开始, 启动项管理就变得面目全非,不可识别.如下图. 于是...

经过一个周末的摸索,总算搞清楚了一些,但也只是搞清了一些,不是全部.

![startup](https://github.com/neo515/launchHub/blob/main/images/startup.jpg)

## mac的服务自启动方式
- 1. loginItem: 一般就是应用程序设置里的"开机时自动启动"
- 2. 系统服务: 分为系统级和用户服务
- 3. 启动项: 系统设置 --> 通用 --> 登录项与扩展上方的"登录时打开"显示的列表项
> 我们一般能够自行添加的就是loginitem 和 启动项.   
>登录项与扩展下方的"允许在后台"一般是应用自行添加的, 我们只能控制是否启动,无法通过这里进行添加和删除

## 重点介绍下系统服务
> loginitem是在程序的设置里去打开和关闭, "启动项"是在系统设置里手动添加和删除.这两个没啥好说的.  
> 下文会讲到哪些应用有loginitem相关的开关. 注意并不是每个应用都有这个设置,微信(v3.8.10)就没有,微信这回良心了.

mac系统的服务管理是通过plist文件来描述的. plist文件位于以下的位置（来源于man手册）
```
~/Library/LaunchAgents         Per-user agents provided by the user.  
/Library/LaunchAgents          Per-user agents provided by the administrator.  
/Library/LaunchDaemons         System wide daemons provided by the administrator.  
/System/Library/LaunchAgents   OS X Per-user agents.  
/System/Library/LaunchDaemons  OS X System wide daemons.  
```
> 一般我们可能要操作的是前3个目录.

## mac系统服务的管理
mac下服务的管理是通过自带的工具launchctl来控制的. 
> launchctl相当的复杂, 学习起来并不是那么的顺利,随着系统版本的更迭,很多subcommand已经不兼容.  
> 官方也声明不会完全兼容,所以资料也是参差不齐一言难尽.
```shell
     launchctl list       # 用于获取当前用户的服务列表
sudo launchctl list       # 用于获取...  // 我也不清楚
# 目前已知的是,命令有没有sudo,输出是不一样的, 不是包含的关系.或许可以简单理解为当前用户和root用户
# 另外,list子命令属于"LEGACY SUBCOMMANDS" (可能mac官方自己也意识到了launchctl的混乱)

# 参考deepseek的说法:
# 在macOS中，`launchctl`命令在较新的版本中（从macOS 10.10 Yosemite开始）引入了新的管理方式，称为"launchd domain"，
# 并且逐步淘汰了一些旧的子命令（被标记为LEGACY）。
# 但是，`launchctl list`仍然被广泛使用，尽管它被标记为LEGACY，但苹果还没有完全移除它。

# launchctl print或许是新的代替命令, 但是现在它还没有是, 它并没有能输出所有的服务,
# 另外还引入了让人费解的domain概念, domain列表如下.
system/[service-name]
user/<uid>/[service-name]
gui/<uid>/[service-name]
login/<asid>/[service-name]
pid/<pid>/[service-name]

# 可能官方的意思是以后通过domain来管理服务,目前还在完善中吧.
```

## 项目能力:
plistFileInfo.py:    扫描系统的服务文件plist

LoginItemManage.sh:  查看当前机器上哪些app有loginitem

BinFileCodesign.sh:  获取二进制的签名

brewServicePlist.sh: 查看brew安装的service对应的plist

reloadlaunchctl.sh:  launchctl如何来重载服务

svcOnDomain.sh:      获取每个domain下的服务

## TODO
目前很难说清楚系统设置 --> 通用 --> 登录项与扩展上方的"允许在后台"显示的列表项都具体是如何在这里显示的,它读取了哪些 都分别对应哪些plist 目前我也不知道. 需要进一步深入学习

## 上面图片上的"Hashicorp, Inc"是怎么回事
先说答案, 据说这个名字来自于二进制程序的签名Codesign. 

通过BinFileCodesign.sh脚本可以获取到二进制的签名信息,确实是匹配的.

但是有很大程序,并不是通过codesign来获取的,所以也很混乱.

据说这里显示的名字,可能老源于codesign、plist文件中的label,但是总是不能完全对得上.又有说这里显示的名字只是截取了部分

## 完善补充
如果各位看官有新的发现,请帮助我补充一下
