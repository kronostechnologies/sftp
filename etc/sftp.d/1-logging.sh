#!/bin/bash
set -e

mkdir -p /etc/td-agent-bit/input.d/

for d in /home/*/; do
  user="$(echo $d | cut -d/ -f3)"
  mkdir -p "/home/${user}/dev"
  cat << EOF > "/etc/td-agent-bit/input.d/${user}.conf"
[INPUT]
    Name        syslog
    Unix_Perm   0666
    Path        /home/${user}/dev/log
    Tag         syslog
EOF
done

echo "LogLevel ${log_level:-INFO}" >> /etc/ssh/sshd_config
sed -i "s~ForceCommand internal-sftp~ForceCommand internal-sftp -l ${log_level:-INFO}~g" /etc/ssh/sshd_config

/opt/td-agent-bit/bin/td-agent-bit -c /etc/td-agent-bit/td-agent-bit.conf &
sleep 2