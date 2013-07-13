#
# Cookbook Name:: hadoop-hdp
# Recipe:: hive client
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


package "hive" do
  action :install
end


template "/etc/hive/conf/hive-site.xml" do
  source "hive-site.xml.erb"
  owner "root"
  group "root"
  mode 0755
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

