# /etc/puppet/modules/hadoop2/manifests/yarn/proxy.pp

class hadoop2::yarn::proxy {
	
	file { "/etc/init.d/hadoop-proxyserver":
		mode => 755,
		source => "puppet:///modules/hadoop2/hadoop-proxyserver",
	}
	
	service { "hadoop-proxyserver":
  		enable => true,
	}
}