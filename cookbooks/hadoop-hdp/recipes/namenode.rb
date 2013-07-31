#
# Cookbook Name:: hadoop-hdp
# Recipe:: namenode
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


package "hadoop-namenode" do
  action :install
end


script "Setting Permissions for NameNode format" do
  interpreter "bash"
  user "root"
  code <<-EOH
  mkdir #{node[:hortonworks_hdp][:namenode][:dfs_name_dir_root]}
  chown -R hdfs:hadoop #{node[:hortonworks_hdp][:namenode][:dfs_name_dir_root]}
  EOH
  not_if { ::File.exists?("#{node[:hortonworks_hdp][:namenode][:dfs_name_dir_root]}") }
end


execute "Namenode format" do
	#command "chown -R hdfs  #{node[:hortonworks_hdp][:namenode][:dfs_name_dir_root]}/*"
  command "su - hdfs -c '/usr/lib/hadoop/bin/hadoop namenode -format'"
  #ignore_failure true
  not_if { ::File.exists?("#{node[:hortonworks_hdp][:namenode][:dfs_name_dir_root]}/var/lib/hadoop/cache/hadoop/dfs/name") }
end

service "hadoop-namenode" do
  action [ :enable, :start ]
end


# mkdir #{node[:hortonworks_hdp][:namenode][:dfs_name_dir_root]}
# chown -R hdfs:hadoop /media/ephemeral0/
