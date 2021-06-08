#!/bin/bash

set -e

ip rule add from 127.0.0.1/8 iif lo table 123
ip route add local 0.0.0.0/0 dev lo table 123

mmproxy_listen="-4 127.0.0.1:22"

if [[ "$(sysctl -en net.ipv6.conf.lo.disable_ipv6)" == "0" ]]; then
  ip -6 rule add from ::1/128 iif lo table 123
  ip -6 route add local ::/0 dev lo table 123
  mmproxy_listen="${mmproxy_listen} -6 [::1]:22"
fi

echo "0.0.0.0/0" > /tmp/go-mmproxy

go-mmproxy -l 0.0.0.0:2222 ${mmproxy_listen} -allowed-subnets /tmp/go-mmproxy &

if [ ! -z "${ssh_host_ed25519_key}" ]
then
  echo "${ssh_host_ed25519_key}" > /etc/ssh/ssh_host_ed25519_key && chmod 600 /etc/ssh/ssh_host_ed25519_key
fi

if [ ! -z "${ssh_host_rsa_key}" ]
then
  echo "${ssh_host_rsa_key}" > /etc/ssh/ssh_host_rsa_key && chmod 600 /etc/ssh/ssh_host_rsa_key
fi

if [ ! -z "${log_level}" ]
then
  echo "LogLevel ${log_level}" >> /etc/ssh/sshd_config
fi

if [ ! -z "${max_startups}" ]
then
  echo "MaxStartups ${max_startups}" >> /etc/ssh/sshd_config
fi

./entrypoint "$@"
