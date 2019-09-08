#!/bin/sh

set -e

PROGRAM=sdkgen

WORKDIR=$(dirname "$0")
exec "${WORKDIR}"/../rundos.sh "${PROGRAM}"

