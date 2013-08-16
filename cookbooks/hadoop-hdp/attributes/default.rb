default[:hortonworks_hdp][:manage_all_config_files] = false
default[:hortonworks_hdp][:nofiles] = 32768
default[:hortonworks_hdp][:swapfile_location] = "/media/ephemeral0/swapfile"
#default[:hortonworks_hdp][:swapfile_location] = "/swapfile"

default[:hortonworks_hdp][:namenode][:host] = "hadoop-hdp-node1"
default[:hortonworks_hdp][:namenode][:port] = "8020"
default[:hortonworks_hdp][:namenode][:safemode_min_datanodes] = 3
default[:hortonworks_hdp][:namenode][:num_dfs_replicas] = 3
default[:hortonworks_hdp][:namenode][:dfs_name_dir] = "/media/ephemeral0/var/lib/hadoop/cache/hadoop/dfs/name" 
default[:hortonworks_hdp][:namenode][:hadoop_tmp_dir] = "/media/ephemeral0/var/lib/hadoop/cache/${user.name}"
default[:hortonworks_hdp][:namenode][:dfs_name_dir_root] = ""

# default[:hortonworks_hdp][:namenode][:dfs_name_dir] = "/var/lib/hadoop/cache/hadoop/dfs/name" 
# default[:hortonworks_hdp][:namenode][:hadoop_tmp_dir] = "/var/lib/hadoop/cache/${user.name}"
# default[:hortonworks_hdp][:namenode][:dfs_name_dir_root] = "/hadoop"

#DataNode

default[:hortonworks_hdp][:datanode][:dfs_data_dir] = "/media/ephemeral0/var/lib/hadoop/cache/hdfs/dfs/data"  
#default[:hortonworks_hdp][:datanode][:dfs_data_dir] = "/hadoop/var/lib/hadoop/cache/hdfs/dfs/data"

#Map Reduce
default[:hortonworks_hdp][:jobtracker][:host] = "hadoop-hdp-node2"
default[:hortonworks_hdp][:jobtracker][:port] = "8021"
# default[:hortonworks_hdp][:mapreduce][:mapred_child_java_opts] = "-server -Xmx2048m -Djava.net.preferIPv4Stack=true"
# default[:hortonworks_hdp][:mapreduce][:mapred_map_child_java_opts] = "-server -Xmx2048m -Djava.net.preferIPv4Stack=true"
# default[:hortonworks_hdp][:mapreduce][:mapred_reduce_child_java_opts] = "-server -Xmx4096m -Djava.net.preferIPv4Stack=true"

default[:hortonworks_hdp][:mapreduce][:mapred_child_java_opts] = "-server -Xmx512m -Djava.net.preferIPv4Stack=true"
default[:hortonworks_hdp][:mapreduce][:mapred_map_child_java_opts] = "-server -Xmx512m -Djava.net.preferIPv4Stack=true"
default[:hortonworks_hdp][:mapreduce][:mapred_reduce_child_java_opts] = "-server -Xmx1024m -Djava.net.preferIPv4Stack=true"


#HDFS
default[:hortonworks_hdp][:hdfs][:tmp_dir] = "/tmp"


#HiveServer2
default[:hortonworks_hdp][:hiveserver][:host] = "hadoop-hdp-node2"
default[:hortonworks_hdp][:hiveserver][:javax_jdo_option_ConnectionURL] = "jdbc:mysql://localhost:3306/hivedb?createDatabaseIfNotExist=true&amp;useUnicode=true&amp;characterEncoding=latin1"
default[:hortonworks_hdp][:hiveserver][:lib] = "/usr/lib/hive/lib"
default[:hortonworks_hdp][:mysql][:jdbc_connector] = "http://repo1.maven.org/maven2/mysql/mysql-connector-java/5.1.9/mysql-connector-java-5.1.9.jar"
default[:hortonworks_hdp][:mysql][:hivedb] = "hivedb"
default[:hortonworks_hdp][:mysql][:hivedb_user_name] = "hivedb_user"
default[:hortonworks_hdp][:mysql][:hivedb_user_password] = "b332a50ecec5bf5970328be5268e4d36"
