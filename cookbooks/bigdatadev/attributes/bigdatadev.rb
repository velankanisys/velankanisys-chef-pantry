#Zookeeper
default[:bigdatadev][:hadoop][:zookeeper_data_dir] = "/mnt/var/lib/zookeeper"



#Accumulo
default[:bigdatadev][:accumulo][:path] = "https://archive.apache.org/dist/incubator/accumulo/1.3.5-incubating/accumulo-1.3.5-incubating-dist.tar.gz"
default[:bigdatadev][:accumulo][:dist] = "accumulo-1.3.5-incubating"
default[:bigdatadev][:accumulo][:home_dir] = '/usr/local/accumulo'

#Hadoop CDH on Ubuntu 12.04.1 LTS
default[:bigdatadev][:hadoop][:dist] = "cdh4"
default[:bigdatadev][:hadoop][:path] = "http://archive.cloudera.com/cdh4/one-click-install/precise/amd64/cdh4-repository_1.0_all.deb"
default[:bigdatadev][:hadoop][:java_home] = "/usr/lib/jvm/default-java"
default[:bigdatadev][:hadoop][:user] = "cdhuser"
default[:bigdatadev][:hadoop][:install_user] = "root"
default[:bigdatadev][:hadoop][:tmp_dir] = "/tmp"
default[:bigdatadev][:hadoop][:dfs_namenode_name_dir] = "/hadoop/nn"
default[:bigdatadev][:hadoop][:dfs_namenode_checkpoint_dir] = "/hadoop/sn"
default[:bigdatadev][:hadoop][:dfs_datanode_data_dir] = "/hadoop/data"
default[:bigdatadev][:hadoop][:dfs_root] = "/hadoop"


#Hadoop HDP on CentOS 6.3
# default[:bigdatadev][:hadoop][:dist] = "hdp"
# default[:bigdatadev][:hadoop][:yum_repo_path] = "http://public-repo-1.hortonworks.com/HDP/centos6/1.x/GA/1.3.0.0/hdp.repo"
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
