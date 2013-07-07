
## Mesos

default[:mesos][:wget_path] = "https://velankani.box.com/shared/static/e3d8a58ynvij6f4yi21t.rpm"
default[:mesos][:home] = "/usr/local/mesos"
default[:mesos][:master] = "hadoop-bdas-node1"
default[:mesos][:slaves_prefix] = 'hadoop-bdas-node' 
default[:mesos][:ssh_key] = "key"