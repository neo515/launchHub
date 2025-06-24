## 获取所有domain的svc
# 实际输出可能包含了很多系统的服务, 所以该脚本暂时仅做参考, 可能需要改进 @TODO

export PATH=$PATH:/opt/homebrew/bin/


svcOnUserDomain(){
    # 系统域
    type=$1
    uid=$2
    echo sudo launchctl print ${type}/${uid}
    sudo launchctl print ${type}/${uid} 2>/dev/null | \
        gsed -n '/^\tservices = {/,/unmanaged processes = {/p'| \
        grep -vE '{|}'|grep -v '^\s*$' | \
        awk -v type=$type -v uid=$uid '{print type"/"uid,$0}'|gsed 's/[[:space:]]\+/ /g'
}

svcOnSystemDomain(){
    # 所有用户域
    sudo launchctl print system | \
        gsed -n '/^\tservices = {/,/unmanaged processes = {/p'| \
        grep -vE '{|}'|grep -v '^\s*$'| \
        awk '{print "system",$0}' | gsed 's/[[:space:]]\+/ /g'
}

svcUser(){
    username=$1
    uid=`id -u`
    svcOnUserDomain gui $uid
    svcOnUserDomain user $uid
}

svcAllDomain(){
    svcOnSystemDomain
    for uid in $(dscl . list /Users UniqueID | awk '{print $2}'); do
        svcOnUserDomain gui $uid
        svcOnUserDomain user $uid
    done

}

# svcOnUser neo