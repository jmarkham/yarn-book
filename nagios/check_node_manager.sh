#!/bin/bash

# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

VERSION="Version 1.0"

PROGNAME=`/bin/basename $0`

# Exit codes
STATE_OK=0
STATE_CRITICAL=2

version() {
   echo "$PROGNAME - $VERSION"
}

usage() {
   echo "Usage: $PROGNAME [-v] -w <limit> -c <limit>"
}

help() {
   version
   echo "Check the NodeManager process\n"
   usage
}

while [ "$1" ]; do
   case "$1" in
       -h | --help)
           help
           exit $STATE_OK
           ;;
       -V | --version)
           version
           exit $STATE_OK
           ;;
       -v | --verbose)
           : $(( verbosity++ ))
           shift
           ;;
       -?)
           usage
           exit $STATE_OK
           ;;
       *)
           echo "$PROGNAME: Invalid option '$1'"
           usage
           exit $STATE_UNKNOWN
           ;;
   esac
done

status=$(/sbin/service hadoop-nodemanager status)

if echo "$status" | grep --quiet running ; then
   echo "NodeManager OK - $status"
   exit $STATE_OK
else
   echo "NodeManager CRITICAL - $status"
   exit $STATE_CRITICAL
fi
