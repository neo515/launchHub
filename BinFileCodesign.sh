
binCodesign(){
    binFile=$1
    codesign --display --verbose=4  "$binFile" 2>&1|grep 'Developer ID Application' |awk -F": " '{print $2}'
}



test () {
    BINs=(
        "/Library/Application Support/Better365/XApp/XAppTool.app/Contents/MacOS/XAppTool"
        "/Applications/Utilities/Adobe Creative Cloud Experience/CCXProcess/CCXProcess.app/Contents/MacOS/CCXProcess"
        "/Users/neo/Library/Application Support/Google/GoogleUpdater/Current/GoogleUpdater.app/Contents/MacOS/GoogleUpdater"
        "/Library/PrivilegedHelperTools/com.microsoft.autoupdate.helper"
        "/Library/Input Methods/SogouInput.app/Contents/SogouServices"
        "/Library/Input Methods/SogouInput.app/Contents/SogouTaskManager.app/Contents/MacOS/SogouTaskManager"
        "/Library/PrivilegedHelperTools/com.trendmicro.TrendCleanerPro.HelperTool"
        "/opt/vagrant-vmware-desktop/bin/vagrant-vmware-utility"
    )

    for bin in "${BINs[@]}";do
        # echo '====================================='
        # echo
        echo "$bin" @ `binCodesign "$bin"`
    done |sort -k2 -t '@' |column -t -s '@'

}

test
