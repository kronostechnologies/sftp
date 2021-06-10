#!/bin/bash
set -e

if [[ "${use_mmproxy}" == "1" ]]; then
  echo "${mmproxy_allowed_networks:-10.0.0.0/8,172.16.0.0/12,192.168.0.0/16}" | tr ',' '\n' > /tmp/go-mmproxy
  declare -a mmproxy_flags=( -l "0.0.0.0:22" -allowed-subnets /tmp/go-mmproxy )

  ip rule add from 127.0.0.1/8 iif lo table 123
  ip route add local 0.0.0.0/0 dev lo table 123
  echo "ListenAddress 127.0.0.1:10022" >> /etc/ssh/sshd_config
  mmproxy_flags+=( -4 "127.0.0.1:10022" )

  if [[ "$(sysctl -en net.ipv6.conf.lo.disable_ipv6)" == "0" ]]; then
    ip -6 rule add from ::1/128 iif lo table 123
    ip -6 route add local ::/0 dev lo table 123
    echo "ListenAddress [::1]:10022" >> /etc/ssh/sshd_config
    mmproxy_flags+=( -6 "[::1]:10022" )
  fi

  if [ ! -z "${mmproxy_verbose}" ]; then
    mmproxy_flags+=( -v "${mmproxy_verbose}" )
  fi

  go-mmproxy "${mmproxy_flags[@]}" 2>&1 | logger -t go-mmproxy &
fi