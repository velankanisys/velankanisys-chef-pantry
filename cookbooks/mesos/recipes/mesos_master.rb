#
# Cookbook Name:: mesos
# Recipe:: [Setup a Mesos Resource Manager Environment - Master]
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



template "mesos-master" do
  path "/etc/init/mesos-master.conf"
  source "mesos-master-init.conf.erb"
  owner "root"
  group "root"
  mode "0755"
  notifies :enable, "service[mesos-master]"
  notifies :start, "service[mesos-master]"
end

service "mesos-master" do
    provider Chef::Provider::Service::Upstart
    supports :status => true, :restart => true
    action [:enable, :start]
end 