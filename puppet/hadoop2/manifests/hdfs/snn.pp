# /etc/puppet/modules/hadoop2/manifests/hdfs/snn.pp

class hadoop2::hdfs::snn {
	
	require hadoop2::params
	
	file { "${hadoop2::params::snn_data_dir}":
    	ensure => "directory",
    	owner  => "hdfs",
    	group  => "hadoop",
	}
	
	file { "/etc/init.d/hadoop-secondarynamenode":
		mode => 755,
		source => "puppet:///modules/hadoop2/hadoop-secondarynamenode",
	}
	
	service { "hadoop-secondarynamenode":
  		enable => true,
	}
}