# /etc/puppet/modules/hadoop2/manifests/hdfs/nn.pp

class hadoop2::hdfs::nn {

	require hadoop2::params
    
    file { "${hadoop2::params::nn_data_dir}":
    	ensure => "directory",
    	owner  => "hdfs",
    	group  => "hadoop",
	}
	
	exec { "${hadoop2::params::hadoop_home}/bin/hdfs namenode -format":
		user => "hdfs",
		alias => "format-hdfs",
		refreshonly => true,
	}
	
	exec { "${hadoop2::params::hadoop_home}/bin/hadoop fs -mkdir -p /mapred/history/done_intermediate":
		user => "hdfs",
		refreshonly => true,
	}
	
	exec { "${hadoop2::params::hadoop_home}/bin/hadoop fs -chown -R mapred:hadoop /mapred":
		user => "hdfs",
		refreshonly => true,
	}
	
	exec { "${hadoop2::params::hadoop_home}/bin/hadoop fs -chmod -R g+rwx /mapred":
		user => "hdfs",
		refreshonly => true,
	}
	
	file { "/etc/init.d/hadoop-namenode":
		mode => 755,
		source => "puppet:///modules/hadoop2/hadoop-namenode",
	}
	
	service { "hadoop-namenode":
  		enable => true,
	}
}