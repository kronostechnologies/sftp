#!/bin/bash
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
