#
# Cookbook Name:: automator
# Recipe:: [Download cookbooks and configure chef-solo]
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

include_recipe "automator::rundeck"

cookbooks_path = node[:automator][:orchestrator][:cookbooks_path]
cookbooks = node[:automator][:orchestrator][:cookbooks]

remote_file "/tmp/#{cookbooks}.tar.gz" do
  source "#{cookbooks_path}"
  not_if { File.exists?("/tmp/#{cookbooks}.tar.gz") }
end


script "Configuring chef-solo" do
  interpreter "bash"
  user "root"
  code <<-EOH
  tar -zxvf /tmp/#{cookbooks}.tar.gz -C /etc/chef/
  EOH
end

template "/etc/chef/solo.rb" do
  source "solo.rb.erb"
  mode 0644
end

template "/etc/chef/initial.json" do
  source "initial.json.erb"
  mode 0644
end

template "/etc/chef/update_boot.json" do
  source "update_boot.json.erb"
  mode 0644
end
