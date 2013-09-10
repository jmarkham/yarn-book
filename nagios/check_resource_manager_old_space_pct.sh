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
STATE_WARNING=1
STATE_CRITICAL=2
STATE_UNKNOWN=3

source /etc/profile.d/hadoop.sh
source /etc/profile.d/java.sh
source /etc/rc.d/init.d/functions
source ${HADOOP_HOME}/etc/hadoop/hadoop-env.sh
source ${HADOOP_HOME}/etc/hadoop/yarn-env.sh

PIDFILE="${YARN_PID_DIR}/yarn-yarn-resourcemanager.pid"

version() {
   echo "$PROGNAME - $VERSION"
}

usage() {
   echo "Usage: $PROGNAME [-v] -w <limit> -c <limit>"
}

help() {
   version
   echo "Check the ResourceManager Heap Old Space % used\n"
   usage
}

warn=
critical=

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
       -w | --warning | -c | --critical)
           if [[ -z "$2" || "$2" = -* ]] ; then
               echo "$PROGNAME: Option '$1' requires an argument"
               print_usage
               exit $STATE_UNKNOWN
           elif [[ "$2" = +([0-9]) ]] ; then
               thresh=$2
           else
               echo "$PROGNAME: Threshold must be integer or percentage"
               print_usage
               exit $STATE_UNKNOWN
           fi
           [[ "$1" = *-w* ]] && warn=$thresh || critical=$thresh
           shift 2
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

if [[ -z "$warn" || -z "$critical" ]]; then
   echo "$PROGNAME: Threshold not set"
   usage
   exit $STATE_UNKNOWN
elif [[ "$critical" -lt "$warn" ]]; then
   echo "$PROGNAME: Warning Old Space % should be more than critical Old Space %"
   usage
   exit $STATE_UNKNOWN
fi


pct=$("$JAVA_HOME"/bin/jstat -gcutil $(cat "$PIDFILE") | awk 'FNR == 2 {print $4}')

if [ "$pct" > "$critical" ] ; then
   printf "ResourceManager Heap Old Space %% used %s - %g" CRITICAL "$pct"
   exit $STATE_CRITICAL
elif [ "$pct" > "$warn" ]; then
   printf "ResourceManager Heap Old Space %% used %s - %g" WARN "$pct"
   exit $STATE_WARNING
else
   printf "ResourceManager Heap Old Space %g%% used is %s" "$pct" OK
   exit $STATE_OK
fi
