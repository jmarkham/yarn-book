# /etc/puppet/modules/hadoop2/manifests/hdfs/directories.pp

class hadoop2::hdfs::directories {

	require hadoop2::params
	
	file { "${hadoop2::params::hdfs_log_dir}":
    	ensure => "directory",
    	owner  => "hdfs",
    	group  => "hadoop",
	}
	
	file { "${hadoop2::params::hdfs_pid_dir}":
    	ensure => "directory",
    	owner  => "hdfs",
    	group  => "hadoop",
	}
}