#Hadoop CDH on Ubuntu 12.04.1 LTS
default[:bigdatadev][:hadoop][:dist] = "cdh4"
default[:bigdatadev][:hadoop][:path] = "http://archive.cloudera.com/cdh4/one-click-install/precise/amd64/cdh4-repository_1.0_all.deb"
default[:bigdatadev][:hadoop][:java_home] = "/usr/lib/jvm/jdk1.6.0_37"
default[:bigdatadev][:hadoop][:user] = "cdhuser"
default[:bigdatadev][:hadoop][:install_user] = "vagrant"


#Hadoop HDP on CentOS 6.3
# default[:bigdatadev][:hadoop][:dist] = "hdp"
# default[:bigdatadev][:hadoop][:yum_repo_path] = "http://public-repo-1.hortonworks.com/HDP-1.2.0/repos/centos6/hdp.repo"
# default[:bigdatadev][:hadoop][:java_home] = "/usr/lib/jvm/java/"
# default[:bigdatadev][:hadoop][:user] = "hdpuser"
# default[:bigdatadev][:hadoop][:install_user] = "vagrant"
# default[:bigdatadev][:hadoop][:jdk_path] = "http://public-repo-1.hortonworks.com/ARTIFACTS/jdk-6u31-linux-x64.bin"
# default[:bigdatadev][:hadoop][:jdk] = "jdk-6u31-linux-x64"

#HBase
default[:bigdatadev][:hbase][:dir] = "hbase"
default[:bigdatadev][:hbase][:user] = "hbaseuser"
