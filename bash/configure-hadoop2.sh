#!/bin/bash

HADOOP_VERSION=2.0.5-alpha
HADOOP_HOME=/opt/hadoop-"${HADOOP_VERSION}"

source hadoop-xml-conf.sh

op=
file=
property=
value=
refresh=false

delete()
{
	del_config --file $file --property $property
}

put()
{
	put_config --file $file --property $property --value $value
}

deploy()
{
        echo "Deploying $file to the cluster..."
	pdcp -w ^all_hosts "$file" $HADOOP_HOME/etc/hadoop/
}

restart_hadoop()
{
	echo "Restarting Hadoop 2..."
	pdsh -w ^dn_hosts "service hadoop-datanode stop"
	pdsh -w ^snn_host "service hadoop-secondarynamenode stop"
	pdsh -w ^nn_host "service hadoop-namenode stop"
	pdsh -w ^mr_history_host "service hadoop-historyserver stop"
	pdsh -w ^yarn_proxy_host "service hadoop-proxyserver stop"
	pdsh -w ^nm_hosts "service hadoop-nodemanager stop"
	pdsh -w ^rm_host "service hadoop-resourcemanager stop"

	pdsh -w ^nn_host "service hadoop-namenode start"
	pdsh -w ^snn_host "service hadoop-secondarynamenode start"
	pdsh -w ^dn_hosts "service hadoop-datanode start"
	pdsh -w ^rm_host "service hadoop-resourcemanager start"
	pdsh -w ^nm_hosts "service hadoop-nodemanager start"
	pdsh -w ^yarn_proxy_host "service hadoop-proxyserver start"
	pdsh -w ^mr_history_host "service hadoop-historyserver start"
}

process()
{
	if [ "$op" == "delete" ]
        then
          delete 
        fi

        if [ "$op" == "put" ]
        then
          put
        fi

        deploy

        if $refresh;
        then
         restart_hadoop
        fi 	
}

help()
{
cat << EOF
configure-hadoop2.sh 
 
This script edits Hadoop 2 XML configuration files.  Assumes an existing Hadoop installation.
 
USAGE:  configure-hadoop2.sh [options]
 
OPTIONS:
   -o, --operation        Valid values are 'put' and 'delete'.  A 'put' operation writes
                          the property and value if it doesn't exist and overwrites it
                          if it does exist.  A 'delete' operation removes the property.
                          
   -f, --file             The name of the configuration file.

   -p, --property         The name of the Hadoop configuration property

   -v, --value            The value of the Hadoop configuration property.  Required for a
                          'put' operation, ignored for a 'delete' operation.

   -r, --restart          Flag to restart Hadoop.  Configuration files are deployed to the
                          cluster automatically to \$HADOOP_HOME/etc/hadoop.
                          
   -h, --help             Show this message.
   
EXAMPLES: 
   Add or edit a Hadoop configuration property: 
     configure-hadoop2.sh -f hdfs-site.xml -p dfs.namenode.name.dir -v /path/to/nn/data
   
   Delete a Hadoop configuration property:
     configure-hadoop2.sh -f hdfs-site.xml -p dfs.namenode.name.dir
            
   Add or edit a Hadoop configuration property and restart Hadoop: 
     configure-hadoop2.sh -f hdfs-site.xml -p dfs.namenode.name.dir -v /path/to/nn/data -r
 
EOF
}

while :
do
  case $1 in

    -h | --help)
      help
      exit 0
      ;;
    -o | --operation)
      if [ -n "$2" ];
      then
        if [ "$2" != "put" ] && [ "$2" != "delete" ]
        then
           echo "Operation (-o | --operation)  must be either 'put' or 'delete'"
           exit 1
        fi
        op="$2"
      fi
      shift 2
      ;;
    -f | --file)
      if [ -n "$2" ];
      then
        file="$2"
      fi
      shift 2
      ;;
    -p | --property)
      if [ -n "$2" ];
      then
        property="$2"
      fi
      shift 2
      ;;
    -v | --value)
      value="$2"
      shift 2
      ;;
    -r | --restart)
      refresh=true
      shift
      ;;
    --)
      shift
      break
      ;;
    -*)
      echo "WARN: Unknown option (ignored): $1" >&2
      shift
      ;;
    *)
      break
      ;;
  esac
done

if [ "$op" == "" ]; then
   echo "ERROR: option '-o | --operation' not given. See --help" >&2
   exit 1
fi

if [ "$file" == "" ]; then
   echo "ERROR: option '-f | --file' not given. See --help" >&2
   exit 1
fi

if [ "$property" == "" ]; then
   echo "ERROR: option '-p | --property' not given. See --help" >&2
   exit 1
fi

if [ "$op" == "put" ] && [ "$value" == "" ]; then
   echo "ERROR: option '-o | --operation' given with option '-v | --value' not given. See --help" >&2
   exit 1
fi

process
