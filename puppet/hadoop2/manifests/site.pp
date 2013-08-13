# /etc/puppet/modules/hadoop2/manifests/site.pp

node 'yarn1.apps.hdp' {
  include hadoop2
  include hadoop2::config::files
  include hadoop2::hdfs::directories
  include hadoop2::hdfs::nn
  include hadoop2::hdfs::snn
}

node 'yarn2.apps.hdp' {
  include hadoop2
  include hadoop2::config::files
  include hadoop2::hdfs::directories
  include hadoop2::hdfs::dn
}

node 'yarn3.apps.hdp' {
  include hadoop2
  include hadoop2::config::files
  include hadoop2::hdfs::directories
  include hadoop2::hdfs::dn
}