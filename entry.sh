#!/bin/sh

set -e
[ "$DEBUG" == 'true' ] && set -x

mkdir -p /concourse-keys/keys/web /concourse-keys/keys/worker
ls -al /concourse-keys

file="/concourse-keys/keys/web/tsa_host_key.pub"

if [ -f "$file" ]
then
  echo "Keys exist - skipping generation."
else
  echo "Keys absent - generating new keys."
  ssh-keygen -t rsa -f /concourse-keys/keys/web/tsa_host_key -N ''
  ssh-keygen -t rsa -f /concourse-keys/keys/web/session_signing_key -N ''

  ssh-keygen -t rsa -f /concourse-keys/keys/worker/worker_key -N ''

  cp /concourse-keys/keys/worker/worker_key.pub /concourse-keys/keys/web/authorized_worker_keys
  cp /concourse-keys/keys/web/tsa_host_key.pub /concourse-keys/keys/worker
  echo "Key generation complete."
fi

echo "Exec command: $@"
exec "$@"