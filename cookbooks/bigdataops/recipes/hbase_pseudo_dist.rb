#
# Cookbook Name:: bigdatadev
# Recipe:: [Setup a Big Data Development Environment: HBase]
#
# Copyright 2012, Velankani Information Systems, Inc eng@velankani.net
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
#

# This recipe is for Cloudera Hadoop CDH4 on Ubuntu 12.04.LTS only
# Most of this will refactored in a later version

include_recipe "bigdatadev::hadoop_pseudo_dist"

package "zookeeper-server"
package "hbase"
package "hbase-master"
package "hbase-rest"
package "hbase-regionserver"



dir = node[:bigdatadev][:hbase][:dir]
user = node[:bigdatadev][:hbase][:user]

user node[:bigdatadev][:hbase][:user] do
  system true
  comment "HBase User"
  shell "/bin/false"
end


script "Initiate and start Zookeeper for the first time" do
  interpreter "bash"
  user "root"
  code <<-EOH
  sleep 5
  sudo service zookeeper-server init
  sudo service zookeeper-server start
  EOH
end


template "/etc/security/limits.conf" do
  source "hbase.limits.conf.erb"
  mode 0644
end

template "/etc/hbase/conf/hbase-env.sh" do
  source "hbase-env.sh.erb"
  mode 0644
end

template "/etc/hbase/conf/hbase-site.xml" do
  source "hbase-site.xml.erb"
  mode 0644
end


script "Setting up home directories" do
  interpreter "bash"
  user "root"
  code <<-EOH
  sudo -u hdfs hadoop fs -mkdir  /#{dir}
  sudo -u hdfs hadoop fs -chown #{user} /#{dir}
  EOH
end


service "hbase-master" do
  supports :restart => true
end

service "hbase-rest" do
  supports :restart => true
end

service "hbase-regionserver" do
  supports :restart => true
end



