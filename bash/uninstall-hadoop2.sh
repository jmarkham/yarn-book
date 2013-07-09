#!/bin/bash

HADOOP_VERSION=2.0.5-alpha
HADOOP_HOME="/opt/hadoop-${HADOOP_VERSION}"
NN_DATA_DIR=/var/data/hadoop/hdfs/nn
SNN_DATA_DIR=/var/data/hadoop/hdfs/snn
DN_DATA_DIR=/var/data/hadoop/hdfs/dn
YARN_LOG_DIR=/var/log/hadoop/yarn
HADOOP_LOG_DIR=/var/log/hadoop/hdfs
HADOOP_MAPRED_LOG_DIR=/var/log/hadoop/mapred

echo "Stopping Hadoop 2 services..."
pdsh -w ^dn_hosts "service hadoop-datanode stop"
pdsh -w ^snn_host "service hadoop-secondarynamenode stop"
pdsh -w ^nn_host "service hadoop-namenode stop"
pdsh -w ^mr_history_host "service hadoop-historyserver stop"
pdsh -w ^yarn_proxy_host "service hadoop-proxyserver stop"
pdsh -w ^nm_hosts "service hadoop-nodemanager stop"
pdsh -w ^rm_host "service hadoop-resourcemanager stop"

echo "Removing Hadoop 2 services from run levels..."
pdsh -w ^dn_hosts "chkconfig --del hadoop-datanode"
pdsh -w ^snn_host "chkconfig --del hadoop-secondarynamenode"
pdsh -w ^nn_host "chkconfig --del hadoop-namenode"
pdsh -w ^mr_history_host "chkconfig --del hadoop-historyserver"
pdsh -w ^yarn_proxy_host "chkconfig --del hadoop-proxyserver"
pdsh -w ^nm_hosts "chkconfig --del hadoop-nodemanager"
pdsh -w ^rm_host "chkconfig --del hadoop-resourcemanager"

echo "Removing Hadoop 2 startup scripts..."
pdsh -w ^all_hosts "rm -f /etc/init.d/hadoop-*"

echo "Removing Hadoop 2 distribution tarball..."
pdsh -w ^all_hosts "rm -f /opt/hadoop-2*.tar.gz"

echo "Removing JDK 1.6.0_31 distribution..."
pdsh -w ^all_hosts "rm -f /opt/jdk*"

echo "Removing JDK 1.6.0_31 artifacts..."
pdsh -w ^all_hosts "rm -f sun-java*"
pdsh -w ^all_hosts "rm -f jdk*"

echo "Removing Hadoop 2 home directory..."
pdsh -w ^all_hosts "rm -Rf $HADOOP_HOME"

echo "Removing Hadoop 2 bash environment setting..."
pdsh -w ^all_hosts "rm -f /etc/profile.d/hadoop.sh"

echo "Removing Java bash environment setting..."
pdsh -w ^all_hosts "rm -f /etc/profile.d/java.sh"

echo "Removing /etc/hadoop link..."
pdsh -w ^all_hosts "unlink /etc/hadoop"

echo "Removing Hadoop 2 command links..."
pdsh -w ^all_hosts "unlink /usr/bin/container-executor"
pdsh -w ^all_hosts "unlink /usr/bin/hadoop"
pdsh -w ^all_hosts "unlink /usr/bin/hdfs"
pdsh -w ^all_hosts "unlink /usr/bin/mapred"
pdsh -w ^all_hosts "unlink /usr/bin/rcc"
pdsh -w ^all_hosts "unlink /usr/bin/test-container-executor"
pdsh -w ^all_hosts "unlink /usr/bin/yarn"

echo "Removing Hadoop 2 script links..."
pdsh -w ^all_hosts "unlink /usr/libexec/hadoop-config.sh"
pdsh -w ^all_hosts "unlink /usr/libexec/hdfs-config.sh"
pdsh -w ^all_hosts "unlink /usr/libexec/httpfs-config.sh"
pdsh -w ^all_hosts "unlink /usr/libexec/mapred-config.sh"
pdsh -w ^all_hosts "unlink /usr/libexec/yarn-config.sh"

echo "Uninstalling JDK 1.6.0_31 RPM..."
pdsh -w ^all_hosts "rpm -ev jdk-1.6.0_31-fcs.x86_64"

echo "Removing NameNode data directory..."
pdsh -w ^nn_host "rm -Rf $NN_DATA_DIR"

echo "Removing Secondary NameNode data directory..."
pdsh -w ^snn_host "rm -Rf $SNN_DATA_DIR"

echo "Removing DataNode data directories..."
pdsh -w ^dn_hosts "rm -Rf $DN_DATA_DIR"

echo "Removing YARN log directories..."
pdsh -w ^all_hosts "rm -Rf $YARN_LOG_DIR"

echo "Removing HDFS log directories..."
pdsh -w ^all_hosts "rm -Rf $HADOOP_LOG_DIR"

echo "Removing MapReduce log directories..."
pdsh -w ^all_hosts "rm -Rf $HADOOP_MAPRED_LOG_DIR"

echo "Removing hdfs system account..."
pdsh -w ^all_hosts "userdel -r hdfs"

echo "Removing mapred system account..."
pdsh -w ^all_hosts "userdel -r mapred"

echo "Removing yarn system account..."
pdsh -w ^all_hosts "userdel -r yarn"

echo "Removing hadoop system group..."
pdsh -w ^all_hosts "groupdel hadoop"
