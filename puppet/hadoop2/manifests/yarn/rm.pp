# /etc/puppet/modules/hadoop2/manifests/yarn/rm.pp

class hadoop2::yarn::rm {
	
	file { "/etc/init.d/hadoop-resourcemanager":
		mode => 755,
		source => "puppet:///modules/hadoop2/hadoop-resourcemanager",
	}
	
	service { "hadoop-resourcemanager":
  		enable => true,
	}
}