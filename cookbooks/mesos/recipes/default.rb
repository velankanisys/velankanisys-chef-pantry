#
# Cookbook Name:: mesos
# Recipe:: [Setup a Mesos Resource Manager Environment]
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
package "java-1.6.0-openjdk"
package "java-1.6.0-openjdk-devel"


mesos_rpm = node[:mesos][:wget_path]


script "Installing Mesos" do
  interpreter "bash"
  code <<-EOH
  rpm -ivh #{mesos_rpm}
  EOH
  
  not_if "rpm -qa | egrep 'mesos'"
end


template "mesos.conf" do
  path "/usr/local/mesos/var/mesos/conf/mesos.conf"
  source "mesos.conf.erb"
  owner "root"
  group "root"
  mode "0755"
end


template "masters" do
  path "/usr/local/mesos/var/mesos/deploy/masters"
  source "masters.erb"
  owner "root"
  group "root"
  mode "0755"
end

template "slaves" do
  path "/usr/local/mesos/var/mesos/deploy/slaves"
  source "slaves.erb"
  owner "root"
  group "root"
  mode "0755"
end

template "mesos-deploy-env.sh" do
  path "/usr/local/mesos/var/mesos/deploy/mesos-deploy-env.sh"
  source "slaves.erb"
  owner "root"
  group "root"
  mode "0755"
end