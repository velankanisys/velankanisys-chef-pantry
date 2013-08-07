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

package "upstart"

include_recipe "java::oracle"

mesos_rpm = node[:bdas][:mesos][:wget_path]
scala_source_path = node[:bdas][:scala][:wget_path]
spark_source_path = node[:bdas][:spark][:wget_path]
shark_source_path = node[:bdas][:shark][:wget_path]
scala_dist = node[:bdas][:scala][:dist]
spark_dist = node[:bdas][:spark][:dist]
shark_dist = node[:bdas][:shark][:dist]

remote_file "/usr/local/#{scala_dist}.tar.gz" do
  source "#{scala_source_path}"
  not_if { File.exists?("/usr/local/#{scala_dist}.tar.gz") }
end

remote_file "/usr/local/#{spark_dist}.tar.gz" do
  source "#{spark_source_path}"
  not_if { File.exists?("/usr/local/#{spark_dist}.tar.gz") }
end


remote_file "/usr/local/#{shark_dist}.tar.gz" do
  source "#{shark_source_path}"
  not_if { File.exists?("/usr/local/#{shark_dist}.tar.gz") }
end

script "Installing Scala" do
  interpreter "bash"
  code <<-EOH
  tar -zxvf /usr/local/#{scala_dist}.tar.gz -C /usr/local/
  EOH
  
  not_if { File.exists?("/usr/local/#{scala_dist}") }
end


script "Installing Spark" do
  interpreter "bash"
  code <<-EOH
  tar -zxvf /usr/local/#{spark_dist}.tar.gz -C /usr/local/
  EOH
  
  not_if { File.exists?("/usr/local/#{spark_dist}") }
end

script "Installing Shark" do
  interpreter "bash"
  code <<-EOH
  tar -zxvf /usr/local/#{shark_dist}.tar.gz -C /usr/local/
  EOH
  
  not_if { File.exists?("/usr/local/#{spark_dist}") }
end

template "/usr/local/spark-0.7.2/conf/spark-env.sh" do
  source "spark-env.sh.erb"
  mode 0644
end


template "/usr/local/shark-0.7.0/conf/shark-env.sh" do
  source "shark-env.sh.erb"
  mode 0644
end
template "/usr/local/spark-0.7.2/bin/spark-worker.sh" do
  source "spark-worker.sh.erb"
  mode 0755
end

template "/usr/local/spark-0.7.2/bin/spark-master.sh" do
  source "spark-master.sh.erb"
  mode 0755
end

# template "/etc/init.d/spark-worker" do
#   source "spark-worker-initd.sh.erb"
#   owner "root"
#   group "root"
#   mode "0744"
# end
