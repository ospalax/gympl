#!/bin/sh

PROGRAM=sdkgen

PATH=${PATH}:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

CMD=$(basename "$0")

#
# functions
#

help()
{
    cat <<EOF
NAME
    ${CMD} - Run program inside DOS emulator

DESCRIPTION
    This is a small shell script to simplify the execution of DOS programs
    running inside a dos emulator.

    Each program may require different setup so this makes things a little more
    easier.

    Programs can be run with dosbox or dosemu - dosbox is a better choice and it
    is better supported. Dosemu can be used too but there is nothing extra done,
    program will be run with the default configuration - also beware that dosemu
    will require some settings to be done during the first run.

USAGE
    ${0} [-h|--help]
        This help

    ${0} <program>
        Run particular program

    programs:
        sdkgen
        starsdat

EXAMPLES

    ${0} sdkgen
    ${0} starsdat
EOF
}

#
# main
#

set -e

case "$1" in
    ''|-h|--help)
        help
        exit
        ;;
    starsdat)
        PROGRAM="$1"
        ;;
    sdkgen)
        PROGRAM="$1"
        ;;
    *)
        echo "ERROR: BAD ARGUMENT (TRY: '${0} --help')" 1>&2
        exit 1
        ;;
esac

if which dosbox >/dev/null 2>&1 ; then
    DOS_CMD=dosbox
elif which dosemu >/dev/null 2>&1 ; then
    DOS_CMD=dosemu
else
    echo "ERROR: NO DOSBOX NOR DOSEMU IS INSTALLED" 1>&2
    exit 1
fi

WORKDIR=$(dirname "$0")
cd "${WORKDIR}/${PROGRAM}"/release

case "$DOS_CMD" in
    dosbox)
        exec dosbox -exit -conf dosbox.conf "${PROGRAM}".exe
        ;;
    dosemu)
        exec dosemu "${PROGRAM}".exe
        ;;
esac

