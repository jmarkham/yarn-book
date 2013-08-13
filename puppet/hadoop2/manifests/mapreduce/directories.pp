# /etc/puppet/modules/hadoop2/manifests/mapreduce/directories.pp


class hadoop2::mapreduce::directories {

	require hadoop2::params
	
	file { "${hadoop2::params::mapred_log_dir}":
    	ensure => "directory",
    	owner  => "hdfs",
    	group  => "hadoop",
	}
	
	file { "${hadoop2::params::mapred_pid_dir}":
    	ensure => "directory",
    	owner  => "mapred",
    	group  => "hadoop",
	}
}