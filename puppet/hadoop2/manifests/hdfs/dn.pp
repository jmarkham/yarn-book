# /etc/puppet/modules/hadoop2/manifests/hdfs/dn.pp

class hadoop2::hdfs::dn {

	require hadoop2::params
	
	file { "${hadoop2::params::dn_data_dir}":
    	ensure => "directory",
    	owner  => "hdfs",
    	group  => "hadoop",
	}
	
	file { "/etc/init.d/hadoop-datanode":
		mode => 755,
		source => "puppet:///modules/hadoop2/hadoop-datanode",
	}
	
	service { "hadoop-datanode":
  		enable => true,
	}
}