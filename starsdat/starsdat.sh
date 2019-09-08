#!/bin/sh

set -e

PROGRAM=starsdat

WORKDIR=$(dirname "$0")
exec "${WORKDIR}"/../rundos.sh "${PROGRAM}"
