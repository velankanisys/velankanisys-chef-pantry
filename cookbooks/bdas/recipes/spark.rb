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

spark_wget_path = 


remote_file "/tmp/spark-0.7.0-sources-tgz" do
  source "#{spark_wget_path}"
  not_if { File.exists?("/tmp/spark-0.7.0-sources-tgz") }
end


# sudo mkdir /usr/local/spark


# sudo tar -zxvf spark-0.7.0-sources.tgz -C /usr/local/spark/


# sudo chown -R vagrant:vagrant /usr/local/spark/


# export HIVE_HOME=/usr/local/shark/hive-0.9.0-bin/
# export SCALA_HOME=/usr/local/scala/scala-2.9.2
# export HADOOP_HOME=/var/lib/hadoop/

# cd /usr/local/spark/spark-0.7.0
# sbt/sbt package
