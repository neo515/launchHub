#!/usr/bin/env python3
## 该文件用于扫描系统启动文目录下的plist获取信息.
import os
import plistlib
import subprocess
from pathlib import Path

LAUNCH_AGENTS_DIRs= [
    Path.home() / "Library" / "LaunchAgents" ,    # /Users/neo/Library/LaunchAgents
    Path('/')   / "Library" / "LaunchAgents" ,    # /Library/LaunchAgents/
    Path('/')   / "Library" / "LaunchDaemons" ,   # /Library/LaunchDaemons/
    # Path('/') / "System" / "Library" / "LaunchAgents" ,  # /System/Library/LaunchAgents
    # Path('/') / "System" / "Library" / "LaunchDaemons"   # /System/Library/LaunchDaemons
]

# pickAttrs=["AbandonProcessGroup", "AssociatedBundleIdentifiers", "Crashed", "Disabled", "EnvironmentVariables", "ExitTimeOut", "KeepAlive", "Label", "LimitLoadToSessionType", "MachServices", "OnDemand", "ProcessType", "Program", "ProgramArguments", "RunAtLoad", "SessionCreate", "Sockets", "SoftResourceLimits", "StandardErrorPath", "StandardOutPath", "StartCalendarInterval", "StartInterval", "WorkingDirectory","name","file","agent"]

pickAttrs=["file","Label","Program"]

# 读取plist文件,转成一个类dict对象
def convert(plistFile):
    with open(plistFile, 'rb') as f:
        data = plistlib.load(f)  #类dict对象
        data["file"] = str(plistFile)
        Program=data.get("Program")
        ProgramArguments=data.get("ProgramArguments")
        if (not Program) and ProgramArguments and type(ProgramArguments)== list:
            Program = ProgramArguments[0]
            ProgramArguments=ProgramArguments[1:]
        elif Program and [Program]==ProgramArguments:
            ProgramArguments=""
        data["Program"]=Program
        data["ProgramArguments"]=ProgramArguments
        return data

def add_startup_item(agentPath,label, program, args=None):
    """
    添加新的启动项
    args: list
    add_startup_item("/Library/LaunchAgents/",
        "com.test.abc",
        "/usr/local/nginx/sbin/nginx",
        ["-g",'prefix'])
    """
    plist_path = f"{agentPath}/{label}.plist"
    
    plist_data = {
        'Label': label,
        'Program': program,
        'RunAtLoad': True,
    }
    
    if args:
        plist_data['ProgramArguments'] = [program] + args
    
    with open(plist_path, 'wb') as f:
        plistlib.dump(plist_data, f)
    
    # 加载新的启动项
    subprocess.run(['launchctl', 'load', str(plist_path)])

def remove_startup_item(agentPath,label):
    """移除启动项"""
    plist_path = f"{agentPath}/{label}.plist"    
    # 卸载启动项
    subprocess.run(['launchctl', 'unload', str(plist_path)])
    # 删除plist文件
    # plist_path.unlink()
    os.remove(plist_path)

def listPlistInfo(plistFile):
    data=convert(plistFile)
    for attr in pickAttrs:
        print(data.get(attr,"-"),end=" @ ")
    print()

def main():
    for LAUNCH_AGENTS_DIR in LAUNCH_AGENTS_DIRs:
        for plist in LAUNCH_AGENTS_DIR.glob("*.plist"):
            listPlistInfo(plist)


if __name__ == "__main__":
    main()
