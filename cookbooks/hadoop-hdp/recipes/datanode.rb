#
# Cookbook Name:: hadoop-hdp
# Recipe:: datanode
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

package "hadoop-datanode" do
  action :install
end


script "Creating Data Node Directories and Setting Permissions" do
  interpreter "bash"
  user "root"
  code <<-EOH
  mkdir -p  /mnt/var/lib/hadoop/cache/hdfs/dfs/data
	chown -R hdfs:hadoop /mnt/var/lib/hadoop/cache/hdfs
  EOH
  not_if { ::File.exists?("#{node[:hortonworks_hdp][:namenode][:dfs_name_dir_root]}/var/lib/hadoop/cache/hdfs/dfs/data") }
end


service "hadoop-datanode" do
  action [ :enable, :start ]
end


