#!/bin/bash
source "$(dirname "$0")/func.sh" || { echo 'Can not load the func.sh file, exiting...' >&2 && exit 1 ; }

# k8sup
if [[ "${NO_K8SUP}" != "true" ]]; then
  /workdir/bin/k8sup.sh "$@" &

  # wait for k8s started
  hold_until_kube_apiserver_started

  # Try to get client ssh keys from k8s secrets
  get_all_authorized_keys_from_k8s_secrets &
fi

# Start SSH daemon and hold
/usr/sbin/sshd -D
