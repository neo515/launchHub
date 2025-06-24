## brew plist
# 通过brew start启动后,会将启动项加入到 ~/Library/LaunchAgents/
# 该脚本用于查看brew service的信息

## brew subcommand
# run   启动但不注册
# start 启动并注册
# stop  停止并反注册
# kill  停止并保留注册
# restat 重启并注册

brewSvcPlist(){
    # brew services info  --all  --json
    brew services info  --all  --json|jq -r  '.[] | [.name,.service_name,.running,.file]|@tsv'|column -t
}

brewSvcPlist
