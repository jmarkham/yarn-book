# /etc/puppet/modules/hadoop2/manifests/yarn/nm.pp

class hadoop2::yarn::nm {
	
	file { "/etc/init.d/hadoop-nodemanager":
		mode => 755,
		source => "puppet:///modules/hadoop2/hadoop-nodemanager",
	}
	
	service { "hadoop-nodemanager":
  		enable => true,
	}
}