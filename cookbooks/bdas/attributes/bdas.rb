#Zookeeper
default[:bdas][:hadoop][:zookeeper_data_dir] = "/mnt/var/lib/zookeeper"


#Hadoop CDH on Ubuntu 12.04.1 LTS
default[:bdas][:hadoop][:dist] = "cdh4"
default[:bdas][:hadoop][:path] = "http://archive.cloudera.com/cdh4/one-click-install/precise/amd64/cdh4-repository_1.0_all.deb"
default[:bdas][:hadoop][:java_home] = "/usr/lib/jvm/default-java"
default[:bdas][:hadoop][:user] = "cdhuser"
default[:bdas][:hadoop][:install_user] = "root"
default[:bdas][:hadoop][:tmp_dir] = "/tmp"
default[:bdas][:namenode][:dfs_name_dir] = "/media/ephemeral0/var/lib/hadoop/cache/hadoop/dfs/name"  
default[:bdas][:namenode][:hadoop_tmp_dir] = "/media/ephemeral0/var/lib/hadoop/cache/${user.name}"
default[:bdas][:namenode][:dfs_name_dir_root] = "/media/ephemeral0"


#Hadoop HDP on CentOS 6.3
# default[:bdas][:hadoop][:dist] = "hdp"
# default[:bdas][:hadoop][:yum_repo_path] = "http://public-repo-1.hortonworks.com/HDP-1.2.0/repos/centos6/hdp.repo"
# default[:bdas][:hadoop][:java_home] = "/usr/lib/jvm/java/"
# default[:bdas][:hadoop][:user] = "vagrant"
# default[:bdas][:hadoop][:install_user] = "root"
# default[:bdas][:hadoop][:jdk_path] = "http://public-repo-1.hortonworks.com/ARTIFACTS/jdk-6u31-linux-x64.bin"
# default[:bdas][:hadoop][:jdk] = "jdk-6u31-linux-x64"
# default[:bdas][:hadoop][:tmp_dir] = "/tmp"
# default[:bdas][:hadoop][:dfs_namenode_name_dir] = "/hadoop/nn"
# default[:bdas][:hadoop][:dfs_namenode_checkpoint_dir] = "/hadoop/sn"
# default[:bdas][:hadoop][:dfs_datanode_data_dir] = "/hadoop/data"


#HBase
default[:bdas][:hbase][:dir] = "hbase"
default[:bdas][:hbase][:user] = "hbaseuser"

## BDAS

default[:bdas][:scala][:wget_path] = "https://velankani.box.com/shared/static/0bh9rtxet1mbbgcnibkt.gz"
#default[:bdas][:spark][:wget_path] = "https://velankani.box.com/shared/static/2708yno8fvzms59s40xf.gz"
default[:bdas][:spark][:wget_path] = "http://spark-project.org/download/spark-0.7.2-prebuilt-cdh4.tgz"
default[:bdas][:mesos][:wget_path] = "https://velankani.box.com/shared/static/e3d8a58ynvij6f4yi21t.rpm"
default[:bdas][:scala][:dist] = "scala-2.9.3"
default[:bdas][:spark][:dist] = "scala-0.7.2"
default[:bdas][:scala][:home] = "/usr/local/scala-2.9.3"
default[:bdas][:shark][:home] = "/usr/local/spark-0.7.2"
default[:bdas][:shark][:home] = "/usr/local/shark"
#default[:bdas][:spark][:master] = "hadoop-hdp-node1"
default[:bdas][:spark][:master] = "hadoop-cdh4-node1"
