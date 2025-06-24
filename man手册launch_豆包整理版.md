
# launchctl 命令手册

## 名称
`launchctl` - 与 launchd 交互的工具

## 概要
`launchctl subcommand [arguments...]`

## 描述
`launchctl` 用于与 `launchd` 交互，以管理和检查守护进程（daemons）、代理（agents）和 XPC 服务。

## 基本结构
`launchctl` 可详细检查 `launchd` 的数据结构，包括以下核心概念：
- **域（Domains）**：管理一组服务的执行策略
- **服务（Services）**：可按需启动的虚拟进程
- **端点（Endpoints）**：服务接收消息的入口

## 目标标识符格式
子命令中常用的目标标识符格式包括：
- `system/[service-name]`：系统域或其中的服务，需 root 权限修改
- `user/<uid>/[service-name]`：指定 UID 的用户域服务（iOS 不支持）
- `login/<asid>/[service-name]`：用户登录域服务（iOS 不支持）
- `gui/<uid>/[service-name]`：GUI 相关的用户登录域服务
- `pid/<pid>/[service-name]`：指定 PID 进程的域服务

**示例**：若服务标识符为 `com.apple.example`，且位于 UID 501 的 GUI 域中，则目标标识符为 `gui/501/com.apple.example`

## 核心子命令
### bootstrap / bootout
- **功能**：引导或移除域和服务
- **参数**：
  - 服务路径或标识符
  - 若未指定路径，可操作域本身
- **输出**：引导或移除过程中出现的错误及路径

### enable / disable
- **功能**：启用或禁用指定域中的服务
- **持久化**：状态跨设备启动保持
- **限制**：仅支持系统域、用户域和用户登录域

### kickstart
- **功能**：立即运行指定服务，无视启动条件
- **选项**：
  - `--kk`：若服务已运行，先终止再重启
  - `--pp`：成功后输出新进程或已运行进程的 PID

### attach
- **功能**：将系统调试器附加到服务进程
- **选项**：
  - `--kk`：终止已运行的服务实例
  - `--ss`：强制启动服务
  - `--xx`：在 xpcproxy 执行前附加（仅开发人员使用）

### debug
- **功能**：配置服务的调试参数
- **常用选项**：
  - `--program <path>`：指定替代的可执行文件
  - `--gdb`：启用 libgmalloc 调试
  - `--malloc-stack-logging`：启用内存分配栈日志
  - `--environment VAR=value`：设置环境变量

### kill
- **功能**：向运行中的服务发送信号
- **参数**：
  - 信号名称（如 `SIGTERM`）或编号
  - 服务目标标识符

### blame
- **功能**：打印服务启动的直接原因
- **限制**：仅显示最近的启动原因，用于调试

### print
- **功能**：打印服务或域的详细信息
- **输出内容**：
  - 域：属性、服务列表、端点状态
  - 服务：起源、当前状态、执行上下文、退出状态
- **警告**：输出结构非 API，可能随版本变更

### print-cache
- **功能**：打印 `launchd` 服务缓存内容

### print-disabled
- **功能**：打印指定域中已禁用的服务列表

### plist
- **功能**：打印 Mach-O 文件中的属性列表
- **参数**：可选段/节名称（默认 `__TEXT,__info_plist`）

### procinfo
- **功能**：打印指定 PID 的执行上下文信息
- **权限**：需要 root 权限
- **输出**：Mach 任务端口、异常端口、审计会话等

### hostinfo
- **功能**：打印系统主机特殊端口信息（如主机异常端口）
- **权限**：需要 root 权限

### resolveport
- **功能**：解析进程端口命名空间中的 Mach 端口
- **权限**：需要 root 权限

### examine
- **功能**：创建 `launchd` 快照用于分析
- **参数**：
  - 可选调试工具（用 `@PID` 占位符替代 PID）
- **限制**：仅适用于开发版 `launchd`

### config
- **功能**：设置 `launchd` 域的持久化配置
- **支持参数**：
  - `umask`：设置服务的 umask（八进制数值）
  - `path`：设置服务的 PATH 环境变量
- **生效条件**：需重启系统

### reboot
- **功能**：指示 `launchd` 启动系统重启流程
- **参数**：
  - `system`：默认，完全关闭用户空间后重启
  - `halt`：关闭系统但不重启
  - `userspace`：重启用户空间
  - `logout`：快速登出（不提示保存数据）
  - `apps`：终止非 launchd 启动的应用

### error
- **功能**：将错误码转换为可读字符串
- **参数**：
  - 可选错误域（`posix`、`mach`、`bootstrap`）

### variant / version
- **variant**：打印当前 `launchd` 的版本类型（RELEASE/DEVELOPMENT/DEBUG）
- **version**：打印 `launchd` 版本字符串

##  legacy 子命令
### load / unload
- **功能**：加载/卸载配置文件
- **选项**：
  - `--ww`：覆盖 Disabled 键
  - `--FF`：强制加载/卸载，忽略 Disabled 键
  - `--SS <sessiontype>`：指定会话类型（Aqua/Background/LoginWindow）
  - `--DD <searchpath>`：按搜索路径操作（system/local/all/user）

### submit
- **功能**：提交无配置文件的程序运行
- **选项**：
  - `--ll <label>`：设置作业标签
  - `--pp <program>`：指定执行程序
  - `--oo <path>`：重定向标准输出
  - `--ee <path>`：重定向标准错误

### remove / start / stop
- **remove**：按标签移除作业（不阻塞等待停止）
- **start**：按标签启动作业（用于调试）
- **stop**：按标签停止作业（按需服务可能立即重启）

### list
- **功能**：列出已加载的作业
- **输出**：
  - 三列：PID（运行中）、最后退出状态、作业标签
- **选项**：`--xx`（已不支持）

### setenv / unsetenv / getenv
- **setenv**：设置所有未来进程的环境变量
- **unsetenv**：取消设置环境变量
- **getenv**：打印环境变量值

### export
- **功能**：导出 `launchd` 环境变量用于 shell 脚本

### limit
- **功能**：查看或设置 `launchd` 的资源限制
- **支持资源**：cpu/filesize/data/stack/core/rsrc/memlock/maxproc/maxfiles

### bslist / bsexec / asuser
- **bslist**：已废弃，由 `print` 替代
- **bsexec**：在目标 PID 上下文中执行命令
- **asuser**：在目标用户引导上下文中执行命令

### managerpid / manageruid / managername
- **managerpid**：打印管理当前引导的 `launchd` PID（始终为 1）
- **manageruid**：打印当前 `launchd` 上下文的 UID
- **managername**：打印 `launchd` 作业管理器名称

## 注意事项
1. **输出兼容性**：新子命令的输出非 API，不保证稳定性
2. **交互模式移除**：不再支持交互式模式或 stdin 命令
3. **配置文件变更**：不再从网络加载配置文件，`/etc/launchd.conf` 已废弃
4. **安全限制**：
   - 配置文件需严格权限控制（禁止组/全局写入）
   - 非 root 写入系统目录可能导致系统无法启动

## 配置文件路径
- `~/.config/launchd/`：用户提供的个人代理
- `/Library/LaunchAgents/`：管理员提供的个人代理
- `/Library/LaunchDaemons/`：系统范围的守护进程
- `/System/Library/LaunchAgents/`：OS X 内置个人代理
- `/System/Library/LaunchDaemons/`：OS X 内置系统守护进程

## 退出状态
- `0`：子命令执行成功
- 非零：错误码（可通过 `error` 子命令解析）

## 相关参考
- `launchd.plist(5)`：服务配置文件格式
- `launchd(8)`：守护进程管理器手册
- `audit(8)`：审计系统工具
- `setaudit_addr(2)`：设置审计地址系统调用