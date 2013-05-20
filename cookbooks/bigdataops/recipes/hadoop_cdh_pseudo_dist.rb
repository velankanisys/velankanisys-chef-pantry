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

# This recipe is for Cloudera Hadoop CDH4 on Ubuntu 12.04.LTS only
# Most of this will refactored in a later version


include_recipe "java::oracle"

dist = node[:bigdatadev][:hadoop][:dist]
path = node[:bigdatadev][:hadoop][:path]
java_home = node[:bigdatadev][:hadoop][:java_home]
data_dir = node[:bigdatadev][:hadoop][:data_dir]
user = node[:bigdatadev][:hadoop][:user]

user node[:bigdatadev][:hadoop][:user] do
  system true
  comment "Hadoop User"
  shell "/bin/false"
end

remote_file "/tmp/#{dist}.deb" do
  source "#{path}"
  not_if { File.exists?("/tmp/#{dist}.deb") }
end

script "Installing Cloudera Hadoop CDH4" do
  interpreter "bash"
  user "root"
  code <<-EOH
  dpkg -i /tmp/#{dist}.deb
  curl -s http://archive.cloudera.com/cdh4/ubuntu/precise/amd64/cdh/archive.key | apt-key add -
  apt-get update
  apt-get autoremove -y
  export JAVA_HOME=#{java_home}
  apt-get install hadoop-0.20-conf-pseudo -y
  sleep 5
  EOH
end

template "/etc/hadoop/conf.pseudo.mr1/hdfs-site.xml" do
  source "hdfs-site.xml.erb"
  mode 0644
end

template "/usr/lib/hadoop/libexec/hadoop-config.sh" do
  source "hadoop-config.sh.erb"
  mode 0644
end

template "/usr/lib/hadoop-0.20-mapreduce/bin/hadoop-config.sh" do
  source "hadoop-config-map-reduce.sh.erb"
  mode 0644
end

script "Setting up and starting Cloudera Hadoop CDH4 services" do
  interpreter "bash"
  user "root"
  code <<-EOH
  sudo -u hdfs hdfs namenode -format
  /etc/init.d/hadoop-hdfs-namenode start
  /etc/init.d/hadoop-hdfs-secondarynamenode start
  /etc/init.d/hadoop-hdfs-datanode start
  EOH
end

script "Setting up and starting Cloudera Hadoop MapReduce" do
  interpreter "bash"
  user "root"
  code <<-EOH
  sudo -u hdfs hadoop fs -mkdir /tmp
  sudo -u hdfs hadoop fs -chmod -R 1777 /tmp
  sudo -u hdfs hadoop fs -mkdir /var
  sudo -u hdfs hadoop fs -mkdir /var/lib
  sudo -u hdfs hadoop fs -mkdir /var/lib/hadoop-hdfs
  sudo -u hdfs hadoop fs -mkdir /var/lib/hadoop-hdfs/cache
  sudo -u hdfs hadoop fs -mkdir /var/lib/hadoop-hdfs/cache/mapred
  sudo -u hdfs hadoop fs -mkdir /var/lib/hadoop-hdfs/cache/mapred/mapred
  sudo -u hdfs hadoop fs -mkdir /var/lib/hadoop-hdfs/cache/mapred/mapred/staging
  sudo -u hdfs hadoop fs -chmod 1777 /var/lib/hadoop-hdfs/cache/mapred/mapred/staging
  sudo -u hdfs hadoop fs -chown -R mapred /var/lib/hadoop-hdfs/cache/mapred
  echo "Verifying HDFS file structure"
  sudo -u hdfs hadoop fs -ls -R /
  sleep 3
  /etc/init.d/hadoop-0.20-mapreduce-jobtracker start
  /etc/init.d/hadoop-0.20-mapreduce-tasktracker start
  EOH
end

script "Setting up home directories" do
  interpreter "bash"
  user "root"
  code <<-EOH
  sudo -u hdfs hadoop fs -mkdir  /user/#{user}
  sudo -u hdfs hadoop fs -chown #{user} /user/#{user}
  EOH
end

