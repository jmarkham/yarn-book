# /etc/puppet/modules/hadoop2/manifests/config/files.pp

class hadoop2::config::files {

	require hadoop2::params
	
	file { "${hadoop2::params::hadoop_home}/etc/hadoop/core-site.xml":
		owner => "hdfs",
		group => "hadoop",
		mode => "644",
		alias => "core-site-xml",
		content => template("hadoop2/conf/core-site.xml.erb"),
	}
	
	file { "${hadoop2::params::hadoop_home}/etc/hadoop/hdfs-site.xml":
		owner => "hdfs",
		group => "hadoop",
		mode => "644",
		alias => "hdfs-site-xml",
		content => template("hadoop2/conf/hdfs-site.xml.erb"),
	}
	
	file { "${hadoop2::params::hadoop_home}/etc/hadoop/yarn-site.xml":
		owner => "yarn",
		group => "hadoop",
		mode => "644",
		alias => "yarn-site-xml",
		content => template("hadoop2/conf/yarn-site.xml.erb"),
	}
	
	file { "${hadoop2::params::hadoop_home}/etc/hadoop/mapred-site.xml":
		owner => "mapred",
		group => "hadoop",
		mode => "644",
		alias => "mapred-site-xml",
		content => template("hadoop2/conf/mapred-site.xml.erb"),
	}
	
	file { "/etc/hadoop":
		ensure => link,
		target => "${hadoop2::params::hadoop_home}/etc/hadoop",
	}
	
	file { "/usr/bin":
		ensure => "link",
		target => "${hadoop2::params::hadoop_home}/bin/*",
	}
	
	file { "/usr/libexec":
		ensure => "link",
		target => "${hadoop2::params::hadoop_home}/libexec/*",
	}
}