default[:hortonworks_hdp][:manage_all_config_files] = false
default[:hortonworks_hdp][:nofiles] = 32768
default[:hortonworks_hdp][:swapfile_location] = "/media/ephemeral0/swapfile"


default[:hortonworks_hdp][:namenode][:host] = "hadoop-hdp-node1"
default[:hortonworks_hdp][:namenode][:port] = 8020
default[:hortonworks_hdp][:namenode][:safemode_min_datanodes] = 3
default[:hortonworks_hdp][:namenode][:num_dfs_replicas] = 3
default[:hortonworks_hdp][:namenode][:dfs_name_dir] = "/media/ephemeral0/var/lib/hadoop/cache/hadoop/dfs/name" 
default[:hortonworks_hdp][:namenode][:hadoop_tmp_dir] = "/media/ephemeral0/var/lib/hadoop/cache/${user.name}"

default[:hortonworks_hdp][:jobtracker][:host] = "hadoop-hdp-node2"
default[:hortonworks_hdp][:jobtracker][:port] = 8021
