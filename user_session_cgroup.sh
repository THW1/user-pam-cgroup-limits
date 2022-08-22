#!/usr/bin/bash

# original from Steve Traylen @ CERN
# https://github.com/THW1/user-pam-cgroup-limits

##############################
#  to limit a user session for ssh logins, call the script per pam_exec.so in the PAM sshd module
#  ensure, that the parent cgroup exist and that the relative cgroup limits match your resource hierarchies, i.e., CPU shares relative to the same geenration and relative to the parents 
##################
# > /etc/pam.d/sshd
#  ...
#  session    required     pam_exec.so debug /usr/local/bin/desy_user_session_cgroup.sh
#  ...
##################

if [ "${PAM_USER}" != 'root' ] and [ "${PAM_TYPE}" == "open_session" ]; then
    
  if [ ! -f /run/systemd/system/user-${TMPUID}.slice.d/50-CPUShares.conf ] ; then
    /usr/bin/systemctl set-property  user-${TMPUID}.slice CPUShares=512 MemoryLimit=8G BlockIOWeight=999
  fi
  if [ ! -f /run/tmpfiles.d/user_${TMPUID}.conf ] ; then
    echo "x  /tmp/${TMPUID}" > /run/tmpfiles.d/user_${TMPUID}.conf
  fi
fi

