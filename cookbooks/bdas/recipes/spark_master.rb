#
# Cookbook Name:: bdas
# Recipe:: [Setup a Berkeley Data Analysis Stack Environment - Spark Master]
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


template "spark-master" do
  path "/etc/init/spark-master.conf"
  source "spark-master-init.conf.erb"
  owner "root"
  group "root"
  mode "0755"
  notifies :enable, "service[spark-master]"
  notifies :start, "service[spark-master]"
end

service "spark-master" do
    provider Chef::Provider::Service::Upstart
    supports :status => true, :restart => true
    action [:enable, :start]
end 


