#!/bin/sh

set -e

until [ `ls -A /cert | wc -w` -eq 1 ]
do
  >&2 echo "No valid certs are detected, retrying..."
  sleep 1
done

exec $@