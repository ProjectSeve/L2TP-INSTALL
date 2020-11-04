#!/bin/bash
#==============================================================================
#
#          FILE:  script.sh
#
#         USAGE:  ./script.sh -a <arg1> [-b <arg2>]
#
#   DESCRIPTION:  This is a bash script template that takes one required 
#                 argument and one optional argument.
#
#       WARNING:  ---
#       OPTIONS:  -a   first argument
#                 -b   second argument (optional)
#
#  REQUIREMENTS:  ---
#          BUGS:  ---
#         NOTES:  ---

#        AUTHOR:  Anas Katib, anaskatib@mail.umkc.edu
#   INSTITUTION:  University of Missouri-Kansas City
#       VERSION:  1.0
#       CREATED:  09/01/2017 11:00:00 AM CST
#      REVISION:  ---
#
#==============================================================================

scriptname=$0

function usage {
    echo "USAGE: $scriptname -a <arg1> [-b <arg2>]"
    echo "  -a <arg1>       required argument"
    echo "  -b <arg2>       optional argument"
    echo "  -h              print this message"
    exit 1
}

function aparse {
while [[ $# > 0 ]] ; do
  case "$1" in
    -a)
      ARG1=${2}
      shift
      ;;
    -b)
      OPT=true
      ARG2=${2}
      ;;
  esac
  shift
done
}

# check if proper input is entered
if [[ ($# -eq 0) || ( $@ == *"-h") || ( $1 != "-a" ) || ( ${#2} -eq 0 ) ]] ; then
    usage
    exit 1
fi

echo "OK"

aparse "$@"
set -e

echo -e "\nSCRIPT STARTED.."
echo "Running with arg1 as" $ARG1

if [[ ($OPT) ]] ; then
    if [[ ${#ARG2} -eq 0 ]] ; then
       echo "Error: -b has no value"
       usage
    fi
    echo "Got optional argument as" $ARG2
fi
echo "SCRIPT FINISHED."
exit 0
