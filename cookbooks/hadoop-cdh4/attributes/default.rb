default[:cloudera_cdh][:manage_all_config_files] = false
default[:cloudera_cdh][:nofiles] = 32768
default[:cloudera_cdh][:swapfile_location] = "/swapfile"


default[:cloudera_cdh][:namenode][:host] = "hadoop-cdh4-node1"
default[:cloudera_cdh][:namenode][:port] = "8020"
default[:cloudera_cdh][:namenode][:safemode_min_datanodes] = 3
default[:cloudera_cdh][:namenode][:num_dfs_replicas] = 3
default[:cloudera_cdh][:namenode][:dfs_name_dir] = "/var/lib/hadoop/cache/hadoop/dfs/name" 
default[:cloudera_cdh][:namenode][:hadoop_tmp_dir] = "/var/lib/hadoop/cache/${user.name}"
default[:cloudera_cdh][:namenode][:dfs_name_dir_root] = "/hadoop"

#DataNode

default[:cloudera_cdh][:datanode][:dfs_data_dir] = "/var/lib/hadoop/cache/hdfs/dfs/data"  

#Map Reduce
default[:cloudera_cdh][:jobtracker][:host] = "hadoop-cdh4-node2"
default[:cloudera_cdh][:jobtracker][:port] = "8021"
# default[:cloudera_cdh][:mapreduce][:mapred_child_java_opts] = "-server -Xmx2048m -Djava.net.preferIPv4Stack=true"
# default[:cloudera_cdh][:mapreduce][:mapred_map_child_java_opts] = "-server -Xmx2048m -Djava.net.preferIPv4Stack=true"
# default[:cloudera_cdh][:mapreduce][:mapred_reduce_child_java_opts] = "-server -Xmx4096m -Djava.net.preferIPv4Stack=true"

default[:cloudera_cdh][:mapreduce][:mapred_child_java_opts] = "-server -Xmx512m -Djava.net.preferIPv4Stack=true"
default[:cloudera_cdh][:mapreduce][:mapred_map_child_java_opts] = "-server -Xmx512m -Djava.net.preferIPv4Stack=true"
default[:cloudera_cdh][:mapreduce][:mapred_reduce_child_java_opts] = "-server -Xmx1024m -Djava.net.preferIPv4Stack=true"


#HDFS
default[:cloudera_cdh][:hdfs][:tmp_dir] = "/tmp"


#HiveServer2
default[:cloudera_cdh][:hiveserver][:host] = "hadoop-cdh4-node2"
default[:cloudera_cdh][:hiveserver][:javax_jdo_option_ConnectionURL] = "jdbc:mysql://localhost:3306/hivedb?createDatabaseIfNotExist=true&amp;useUnicode=true&amp;characterEncoding=latin1"
default[:cloudera_cdh][:hiveserver][:lib] = "/usr/lib/hive/lib"
default[:cloudera_cdh][:mysql][:jdbc_connector] = "http://repo1.maven.org/maven2/mysql/mysql-connector-java/5.1.9/mysql-connector-java-5.1.9.jar"
default[:cloudera_cdh][:mysql][:hivedb] = "hivedb"
default[:cloudera_cdh][:mysql][:hivedb_user_name] = "hivedb_user"
default[:cloudera_cdh][:mysql][:hivedb_user_password] = "b332a50ecec5bf5970328be5268e4d36"
default[:cloudera_cdh][:hiveserver][:serdes_wget_path] = "http://files.cloudera.com/samples/hive-serdes-1.0-SNAPSHOT.jar"


#Flume
default[:cloudera_cdh][:flume_source][:wget_path]= "http://files.cloudera.com/samples/flume-sources-1.0-SNAPSHOT.jar"


#oozie
default[:cloudera_cdh][:oozie][:lib] = "/var/lib/oozie"
default[:cloudera_cdh][:mysql][:ooziedb] = "ooziedb"
default[:cloudera_cdh][:mysql][:ooziedb_user_name] = "ooziedb_user"
default[:cloudera_cdh][:mysql][:ooziedb_user_password] = "b332a50ecec5bf5970328be5268e4d36"



