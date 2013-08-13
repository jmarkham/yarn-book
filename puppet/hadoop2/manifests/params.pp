# /etc/puppet/modules/hadoop2/manifests/params.pp

class hadoop2::params {

	$version = $::hostname ? {
		default			=> "2.0.5-alpha",
	}
	
	$nn_data_dir = $::hostname ? {
		default			=> ["/var/data","/var/data/hadoop","/var/data/hadoop/hdfs","/var/data/hadoop/hdfs/nn",]
	}
	
	$snn_data_dir = $::hostname ? {
		default			=> ["/var/data","/var/data/hadoop","/var/data/hadoop/hdfs","/var/data/hadoop/hdfs/snn",]
	}
	
	$dn_data_dir = $::hostname ? {
		default			=> ["/var/data","/var/data/hadoop","/var/data/hadoop/hdfs","/var/data/hadoop/hdfs/dn",]
	}
	
	$hdfs_log_dir = $::hostname ? {
		default			=> ["/var/log/hadoop","/var/log/hadoop/hdfs"]
	}
	
	$yarn_log_dir = $::hostname ? {
		default			=> ["/var/log/hadoop","/var/log/hadoop/yarn"]
	}
	
	$mapred_log_dir = $::hostname ? {
		default			=> ["/var/log/hadoop","/var/log/hadoop/mapred"]
	}
	
	$hdfs_pid_dir = $::hostname ? {
		default			=> ["/var/run/hadoop","/var/run/hadoop/hdfs"]
	}
	
	$yarn_pid_dir = $::hostname ? {
		default			=> ["/var/run/hadoop","/var/run/hadoop/yarn"]
	}
	
	$mapred_pid_dir = $::hostname ? {
		default			=> ["/var/run/hadoop","/var/run/hadoop/mapred"]
	}
	
	$http_static_user = $::hostname ? {
		default			=> "hdfs",
	}
	
	$yarn_proxy_port = $::hostname ? {
		default			=> "8081",
	}
	
	$java_home = $::hostname ? {
		default			=> "/usr/java/jdk1.6.0_31",
	}
	
	$hadoop_home = $::hostname ? {
		default			=> "/opt/hadoop-${hadoop2::params::version}",
	}

}
