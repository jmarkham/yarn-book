# /etc/puppet/modules/hadoop2/manifests/init.pp

class hadoop2 {

	require hadoop2::params	
	
	group { "hadoop":
		ensure => present,
	}

	user { "hdfs":
		ensure => present,
		shell => "/bin/bash",
		require => Group["hadoop"],
	}
	
	user { "yarn":
		ensure => present,
		shell => "/bin/bash",
		require => Group["hadoop"],
	}
	
	user { "mapred":
		ensure => present,
		shell => "/bin/bash",
		require => Group["hadoop"],
	}
	
	file { "/opt/jdk-6u31-linux-x64-rpm.bin":
		mode => 777,
		source => "puppet:///modules/hadoop2/jdk-6u31-linux-x64-rpm.bin",
		alias => "jdk-dist",
		before => Exec["untar-hadoop"]
	}
	
	exec { "/opt/jdk-6u31-linux-x64-rpm.bin -noregister":
		command => "/opt/jdk-6u31-linux-x64-rpm.bin -noregister",
		cwd => "/opt",
		alias => "jdk-install",
		refreshonly => true,
		subscribe => File["jdk-dist"],
	}
	
	file { "/etc/profile.d/java.sh":
        mode    => 0640,
        content => "export JAVA_HOME=/usr/java/jdk1.6.0_31",
    }
		
	file { "/opt/hadoop-${hadoop2::params::version}.tar.gz":
		path => "/tmp/hadoop-${hadoop2::params::version}.tar.gz",
		source => "puppet:///modules/hadoop2/hadoop-${hadoop2::params::version}.tar.gz",
		alias => "hadoop-source-tgz",
		before => Exec["untar-hadoop"]
	}
	
	exec { "untar hadoop-${hadoop2::params::version}.tar.gz":
		command => "/bin/tar -zxf /tmp/hadoop-${hadoop2::params::version}.tar.gz  -C /opt",
		cwd => "/opt",
		alias => "untar-hadoop",
		refreshonly => true,
		subscribe => File["hadoop-source-tgz"],
	}
	
    file { "/etc/profile.d/hadoop.sh":
        mode    => 0640,
        content => "export HADOOP_HOME=${hadoop2::params::hadoop_home} \nexport HADOOP_PREFIX=${hadoop2::params::hadoop_home}",
    }
}
