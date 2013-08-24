#
# Cookbook Name:: bigdatadev
# Recipe:: [Setup a Big Data Development Environment: Hadoop]
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

# This recipe is for HDP 1.2 on CentOS 6.3 only
# Most of this will refactored in a later version

require 'chef/mixin/shell_out'
require 'chef/mixin/language'
#include Chef::Mixin::ShellOut


include_recipe "java::oracle"

dist = node[:bigdatadev][:hadoop][:dist]
path = node[:bigdatadev][:hadoop][:path]
jdk_path = node[:bigdatadev][:hadoop][:jdk_path]
jdk = node[:bigdatadev][:hadoop][:jdk]
java_home = node[:bigdatadev][:hadoop][:java_home]
data_dir = node[:bigdatadev][:hadoop][:data_dir]
user = node[:bigdatadev][:hadoop][:user]
install_user = node[:bigdatadev][:hadoop][:install_user]

user node[:bigdatadev][:hadoop][:user] do
  system true
  comment "Hadoop User"
  shell "/bin/bash"
end


script "Installing HDP 1.3 pseudo dist" do
  interpreter "bash"
  user "#{install_user}"
  code <<-EOH
  echo "root         ALL=(ALL)               NOPASSWD: ALL" >> /etc/sudoers
  wget -nv http://public-repo-1.hortonworks.com/HDP/centos6/1.x/GA/1.3.0.0/hdp.repo -O /etc/yum.repos.d/hdp.repo
  sleep 5
  echo "Installing HDP 1.3. Please wait..."
  sudo yum install hadoop-conf-pseudo.x86_64 -y
  EOH
  
  not_if "rpm -qa | egrep 'hadoop'"
end

template "/etc/hadoop/conf/core-site.xml" do
  source "core-site.xml.erb"
  mode 0644
end


template "/etc/hadoop/conf/hdfs-site.xml" do
  source "hdfs-site.xml.erb"
  mode 0644
end

template "/etc/hadoop/conf/hadoop-env.sh" do
  source "hadoop-env-hdp.sh.erb"
  mode 0644
end

template "/usr/lib/hadoop/libexec/hadoop-config.sh" do
  source "hadoop-config-hdp-libexec.sh.erb"
  mode 0644
end

template "/usr/lib/hadoop/bin/hadoop-config.sh" do
  source "hadoop-config-hdp.sh.erb"
  mode 0644
end

# Will be ractored once an LWRP is written!! (sorry for the ugly script hacks)

script "Setting up and starting HDP 1.3 HDFS" do
  interpreter "bash"
  #user "#{user}"
  code <<-EOH
  sudo mkdir /hadoop
  sudo mkdir /hadoop/nn
  sudo mkdir /hadoop/sn
  sudo mkdir /hadoop/data
  sudo chown -R hdfs:hadoop /hadoop
  sudo -iu hdfs hadoop namenode -format
  sleep 10
  sudo -u hdfs /usr/lib/hadoop/bin/hadoop-daemon.sh --config /etc/hadoop/conf start namenode
  sudo -u hdfs /usr/lib/hadoop/bin/hadoop-daemon.sh --config /etc/hadoop/conf start secondarynamenode
  sudo -u hdfs /usr/lib/hadoop/bin/hadoop-daemon.sh --config /etc/hadoop/conf start datanode
  EOH
  
  not_if { File.exists?("/hadoop/nn") }
end

script "Setting up and starting HDP 1.3 MapReduce" do
  interpreter "bash"
  #user "#{user}"
  code <<-EOH
  sudo -iu hdfs hadoop fs -mkdir /tmp
  sudo -iu hdfs hadoop fs -chmod -R 777 /tmp
  sudo -iu hdfs hadoop fs -mkdir /var
  sudo -iu hdfs hadoop fs -mkdir /var/lib
  sudo -iu hdfs hadoop fs -mkdir /var/lib/hadoop-hdfs
  sudo -iu hdfs hadoop fs -mkdir /var/lib/hadoop-hdfs/cache
  sudo -iu hdfs hadoop fs -mkdir /var/lib/hadoop-hdfs/cache/mapred
  sudo -iu hdfs hadoop fs -mkdir /var/lib/hadoop-hdfs/cache/mapred/mapred
  sudo -iu hdfs hadoop fs -mkdir /var/lib/hadoop-hdfs/cache/mapred/mapred/staging
  sudo -iu hdfs hadoop fs -chmod 777 /var/lib/hadoop-hdfs/cache/mapred/mapred/staging
  echo "Verifying HDFS file structure"
  sudo -iu hdfs hadoop fs -ls -R /
  sleep 3
  sudo -u mapred /usr/lib/hadoop/bin/hadoop-daemon.sh --config /etc/hadoop/conf start jobtracker
  sudo -u mapred /usr/lib/hadoop/bin/hadoop-daemon.sh --config /etc/hadoop/conf start tasktracker
  EOH
  
  not_if "hadoop fs -ls /var/lib/ | awk '{ print $3 }' | egrep 'hdfs'"
end

script "Setting up home directories" do
  interpreter "bash"
  #user "#{user}"
  code <<-EOH
  sudo -iu hdfs hadoop fs -mkdir /user
  sudo -iu hdfs hadoop fs -mkdir  /user/#{user}
  sudo -iu hdfs hadoop fs -chown #{user} /user/#{user}
  EOH
  
  not_if "hadoop fs -ls /user | awk '{ print $3 }' | egrep 'vagrant'"
end


package "pig" do
  action :install
end

package "hive" do
  action :install
end

package "hive-server2" do
  action :install
end

service "hive-server2" do
  action [ :enable, :start ]
end
