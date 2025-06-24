
## launchctl subcommand
# run   启动但不注册
# start 启动并注册
# stop  停止并反注册
# kill  停止并保留注册
# restat 重启并注册



## 主要 Domain 类型
# Domain  作用范围    典型用途    配置文件路径
# system  整个系统(需sudo) 系统级守护进程（如 sshd） /Library/LaunchDaemons/
# gui/<UID>   指定用户的图形会话（当前登录用户）   用户级图形界面应用（如 brew 服务）    ~/Library/LaunchAgents/
# user/<UID>  指定用户的非图形会话（如 SSH 登录）    后台用户进程（较少见） 同 gui/<UID>，但无图形环境权限

# 需要知道domain
reload(){
    service=$1
    sudo launchctl bootout system/$service
    sudo launchctl print   system/$service
    ll /Library/LaunchDaemons/${service}.plist
    sudo launchctl bootstrap system /Library/LaunchDaemons/${service}.plist
    sudo launchctl print   system/$service | grep -E "state|pid"
}
