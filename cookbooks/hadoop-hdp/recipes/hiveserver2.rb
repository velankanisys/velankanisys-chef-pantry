#
# Cookbook Name:: hadoop-hdp
# Recipe:: hiveserver2
#
#
# Author: Murali Raju <murali.raju@appliv.com>
#
# Copyright 2013, Velankani Information Systems, Inc eng@velankani.net
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# cookbooksributed under the License is cookbooksributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


# chown -R hive:hadoop /opt/hive
# mkdir -p /media/ephemeral0/var/lib/hadoop/cache/hive
# chown -R hive:hadoop /media/ephemeral0/var/lib/hadoop/cache/hive

include_recipe "mysql::server"
include_recipe "database::mysql"

hive_server_lib_path = node[:hortonworks_hdp][:hiveserver][:lib]
mysql_connector_java = node[:hortonworks_hdp][:mysql][:jdbc_connector]

package "upstart"

package "hive-server2" do
  action :install
end


service "hive-server2" do
  action :enable
end

template "/etc/hive/conf/hive-site.xml" do
  source "hive-site.xml.erb"
  owner "root"
  group "root"
  mode 0755
  # variables({
  #             :jobtracker_ip => $master_node_ip,
  #             :jobtracker_port => node[:hortonworks_hdp][:jobtracker][:port]
  #           })
end


template "/etc/hive/conf/hive-env.sh" do
  source "hive-env.sh.erb"
  owner "root"
  group "root"
  mode 0755
  # variables({
  #             :jobtracker_ip => $master_node_ip,
  #             :jobtracker_port => node[:hortonworks_hdp][:jobtracker][:port]
  #           })
end


template "/usr/local/bin/hiveserver2-metastore.sh" do
  source "hiveserver2-metastore.sh.erb"
  owner "root"
  group "root"
  mode 0755
  # variables({
  #             :jobtracker_ip => $master_node_ip,
  #             :jobtracker_port => node[:hortonworks_hdp][:jobtracker][:port]
  #           })
end

template "hiveserver2-metastore" do
  path "/etc/init/hiveserver2-metastore.conf"
  source "hiveserver2-metastore-init.conf.erb"
  owner "root"
  group "root"
  mode "0755"
  notifies :enable, "service[hiveserver2-metastore]"
  notifies :start, "service[hiveserver2-metastore]"
end

script "Creating HiveServer Directories and Setting Permissions" do
  interpreter "bash"
  user "root"
  code <<-EOH
  mkdir -p #{node[:hortonworks_hdp][:namenode][:dfs_name_dir_root]}/var/lib/hadoop/cache/hive
  chown -R hive:hadoop #{node[:hortonworks_hdp][:namenode][:dfs_name_dir_root]}/var/lib/hadoop/cache/hive
  EOH
  not_if { ::File.exists?("#{node[:hortonworks_hdp][:namenode][:dfs_name_dir_root]}/var/lib/hadoop/cache/hive") }
end


remote_file "/#{hive_server_lib_path}/mysql-connector-java-5.1.9.jar" do
  source "#{mysql_connector_java}"
  not_if { File.exists?("/#{hive_server_lib_path}/mysql-connector-java-5.1.9.jar") }
end


# execute "Starting Hive Metastore" do
#   command 'su -l hive -c "env HADOOP_HOME=/usr nohup hive --service metastore" > /opt/hive/hive.out 2> /opt/hive/hive.log &'
#   not_if { ::File.exists?("/var/run/hive/hive-server2.pid") }
# end

service "hiveserver2-metastore" do
  action :start
end

service "hive-server2" do
  action :start
end

