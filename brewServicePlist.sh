## brew plist
# 通过brew start启动后,会将启动项加入到 ~/Library/LaunchAgents/
# 该脚本用于查看brew service的信息
brewSvcPlist(){
    # brew services info  --all  --json
    brew services info  --all  --json|jq -r  '.[] | [.name,.service_name,.running,.file]|@tsv'|column -t
}

brewSvcPlist
