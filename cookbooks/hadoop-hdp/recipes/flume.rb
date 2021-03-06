#
# Cookbook Name:: hadoop-hdp
# Recipe:: flume
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

%w'flume
flume-node'.each do | pack |
  package pack do
    action :install
    #options "--force-yes"
  end
end

remote_file "/usr/lib/flume/lib/flume-sources-1.0-SNAPSHOT.jar" do
  source "http://files.cloudera.com/samples/flume-sources-1.0-SNAPSHOT.jar"
  not_if { File.exists?("/usr/lib/flume/lib/flume-sources-1.0-SNAPSHOT.jar") }
end

template "/etc/flume/conf/flume-env.sh" do
  source "flume-env.sh.erb"
  owner "root"
  group "root"
  mode 0755
end

# template "/etc/default/flume-ng-agent" do
#   source "flume-ng-agent.erb"
#   owner "root"
#   group "root"
#   mode 0755
# end

template "/etc/flume/conf/flume.conf" do
  source "flume.conf.erb"
  owner "root"
  group "root"
  mode 0755
end

script "Setting up environment" do
  interpreter "bash"
  user "root"
  code <<-EOH
  sudo -u hdfs hadoop fs -mkdir /user/flume
  sudo -u hdfs hadoop fs -chown flume:flume /user/flume
  sudo -u hdfs hadoop fs -chmod -R 770 /user/flume
  EOH
  not_if { "hadoop fs -ls /user | egrep flume" }
end

template "flume" do
  path "/etc/init/flume.conf"
  source "flume-init.conf.erb"
  owner "root"
  group "root"
  mode "0755"
  notifies :enable, "service[flume]"
  notifies :start, "service[flume]"
end

template "start-flume.sh" do
  path "/usr/local/bin/start-flume.sh"
  source "start-flume.sh.erb"
  owner "root"
  group "root"
  mode "0755"
end

service "flume" do
    provider Chef::Provider::Service::Upstart
    supports :status => true, :restart => true
    action [:enable, :start]
end

