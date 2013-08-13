# /etc/puppet/modules/hadoop2/manifests/yarn/directories.pp

class hadoop2::yarn::directories {

	require hadoop::params
	
	file { "${hadoop::params::yarn_log_dir}":
    	ensure => "directory",
    	owner  => "yarn",
    	group  => "hadoop",
	}		
	
	file { "${hadoop::params::yarn_pid_dir}":
    	ensure => "directory",
    	owner  => "yarn",
    	group  => "hadoop",
	}
}
