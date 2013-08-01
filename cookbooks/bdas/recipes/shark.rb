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

# scala_wget_path = 
# shark_wget_path =  

# remote_file "/tmp/scala-2.9.2.tgz" do
#   source "#{scala_wget_path}"
#   not_if { File.exists?("/tmp/scala-2.9.2.tgz") }
# end

# remote_file "/tmp/#{dist}-server-amd64.iso" do
#   source "#{shark_wget_path}"
#   not_if { File.exists?("/tmp/#{dist}-server-amd64.iso") }
# end


#sudo mkdir /usr/local/shark

#sudo mkdir /usr/local/scala

#sudo tar -zxvf shark-0.2.1-bin.tgz -C /usr/local/shark

#sudo tar -zxvf scala-2.9.2.tgz -C /usr/local/scala/
#sudo chown -R vagrant:vagrant /usr/local/scala/
#sudo chown -R vagrant:vagrant /usr/local/shark/

#export HIVE_HOME=/usr/local/shark/hive-0.9.0-bin/
#export SCALA_HOME=/usr/local/scala/scala-2.9.2
#export HADOOP_HOME=/var/lib/hadoop/
