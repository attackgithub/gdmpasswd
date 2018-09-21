# gdmpasswd
Dumps potential cleartext passwords for the currently logged on user from the gdm-password process memory.

```
root@pwnd:~# ./gdmpasswd.sh 
          __                                               __ 
.-----.--|  |.--------.-----.---.-.-----.-----.--.--.--.--|  |
|  _  |  _  ||        |  _  |  _  |__ --|__ --|  |  |  |  _  |
|___  |_____||__|__|__|   __|___._|_____|_____|________|_____|
|_____|               |__|                                    

USERNAME: root 

PASSWORD CANDIDATES:

close
counts.User'
r00tP@ss!89
files
group
hosts
myhostname
netgroup
networks
passwd
protocols
publickey
services
shadow

root@pwnd:~# 

```

* Due to the where the correct password string ends up in memory, and its "near by" strings, it might not work every time.
