#
# Cookbook Name:: bdas
# Recipe:: [Setup a Berkeley Data Analysis Stack Environment]
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
#


include_recipe "java::oracle"

mesos_rpm = node[:bdas][:mesos][:wget_path]
scala_source_path = node[:bdas][:scala][:wget_path]
spark_source_path = node[:bdas][:spark][:wget_path]
scala_dist = node[:bdas][:scala][:dist]
spark_dist = node[:bdas][:spark][:dist]
spark_home = node[:bdas][:spark][:home] 

remote_file "/tmp/#{scala_dist}.tar.gz" do
  source "#{scala_source_path}"
  not_if { File.exists?("/tmp/#{scala_dist}.tar.gz") }
end

remote_file "/tmp/#{spark_dist}.tar.gz" do
  source "#{spark_source_path}"
  not_if { File.exists?("/tmp/#{spark_dist}.tar.gz") }
end

script "Installing Mesos" do
  interpreter "bash"
  code <<-EOH
  rpm -ivh #{mesos_rpm}
  EOH
  
  not_if "rpm -qa | egrep 'mesos'"
end

script "Installing Scala" do
  interpreter "bash"
  code <<-EOH
  tar -zxvf /tmp/#{scala_dist}.tar.gz -C /usr/local/
  EOH
  
  not_if { File.exists?("/usr/local/#{scala_dist}") }
end


script "Installing Spark" do
  interpreter "bash"
  code <<-EOH
  tar -zxvf /tmp/#{spark_dist}.tar.gz -C /usr/local/
  EOH
  
  not_if { File.exists?("/usr/local/#{spark_dist}") }
end

template "#{spark_home}/conf/spark-env.sh" do
  source "spark-env.sh.erb"
  mode 0644
end