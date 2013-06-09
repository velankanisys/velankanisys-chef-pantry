#Hadoop CDH on Ubuntu 12.04.1 LTS
default[:bigdatadev][:hadoop][:dist] = "cdh4"
default[:bigdatadev][:hadoop][:path] = "http://archive.cloudera.com/cdh4/one-click-install/precise/amd64/cdh4-repository_1.0_all.deb"
default[:bigdatadev][:hadoop][:java_home] = "/usr/lib/jvm/jdk1.6.0_37"
default[:bigdatadev][:hadoop][:user] = "cdhuser"
default[:bigdatadev][:hadoop][:install_user] = "root"
default[:bigdatadev][:hadoop][:tmp_dir] = "/tmp"
default[:bigdatadev][:hadoop][:dfs_namenode_name_dir] = "/mnt/hadoop/nn"
default[:bigdatadev][:hadoop][:dfs_namenode_checkpoint_dir] = "mnt/hadoop/sn"
default[:bigdatadev][:hadoop][:dfs_datanode_data_dir] = "/mnt/hadoop/data"


#Hadoop HDP on CentOS 6.3
# default[:bigdatadev][:hadoop][:dist] = "hdp"
# default[:bigdatadev][:hadoop][:yum_repo_path] = "http://public-repo-1.hortonworks.com/HDP-1.2.0/repos/centos6/hdp.repo"
# default[:bigdatadev][:hadoop][:java_home] = "/usr/lib/jvm/java/"
# default[:bigdatadev][:hadoop][:user] = "vagrant"
# default[:bigdatadev][:hadoop][:install_user] = "root"
# default[:bigdatadev][:hadoop][:jdk_path] = "http://public-repo-1.hortonworks.com/ARTIFACTS/jdk-6u31-linux-x64.bin"
# default[:bigdatadev][:hadoop][:jdk] = "jdk-6u31-linux-x64"
# default[:bigdatadev][:hadoop][:tmp_dir] = "/tmp"
# default[:bigdatadev][:hadoop][:dfs_namenode_name_dir] = "/hadoop/nn"
# default[:bigdatadev][:hadoop][:dfs_namenode_checkpoint_dir] = "/hadoop/sn"
# default[:bigdatadev][:hadoop][:dfs_datanode_data_dir] = "/hadoop/data"


#HBase
default[:bigdatadev][:hbase][:dir] = "hbase"
default[:bigdatadev][:hbase][:user] = "hbaseuser"

## BDAS
# Shark

default[:bigdatadev][:bdas][:scala][:wget_path] = "http://www.scala-lang.org/downloads/distrib/files/scala-2.9.2.tgz"
default[:bigdatadev][:bdas][:shark][:wget_path] = "http://spark-project.org/download-shark-0.2.1-bin.tgz"
default[:bigdatadev][:bdas][:spark][:wget_path] = "http://www.spark-project.org/download-spark-0.7.0-sources-tgz"
default[:bigdatadev][:bdas][:scala][:home] = "/usr/local/scala"
default[:bigdatadev][:bdas][:shark][:home] = "/usr/local/shark"
