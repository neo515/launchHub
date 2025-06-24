# 需要知道domain
reload(){
    service=$1
    sudo launchctl bootout system/$service
    sudo launchctl print   system/$service
    ll /Library/LaunchDaemons/${service}.plist
    sudo launchctl bootstrap system /Library/LaunchDaemons/${service}.plist
    sudo launchctl print   system/$service | grep -E "state|pid"
}
