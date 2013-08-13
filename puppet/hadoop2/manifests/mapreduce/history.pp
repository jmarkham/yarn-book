# /etc/puppet/modules/hadoop2/manifests/mapreduce/history.pp

class hadoop2::mapreduce::history {
	
	file { "/etc/init.d/hadoop-historyserver":
		mode => 755,
		source => "puppet:///modules/hadoop2/hadoop-historyserver",
	}
	
	service { "hadoop-historyserver":
  		enable => true,
	}
}