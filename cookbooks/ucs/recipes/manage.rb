#
# Cookbook Name:: ucs
# Recipe:: basic [Setup Basic Environment]
#
# Copyright 2011, Murali Raju, murali.raju@appliv.com
# Copyright 2012, Velankani Information Systems, eng@velankani.net
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'ucslib'

#Uncomment to debug
#log "Using: #{node[:ucs][:ip]}, #{node[:ucs][:username]}, #{node[:ucs][:password]}"

#JSON Definitions Start
auth_json = {:ip => "#{node[:ucs][:ip]}",
             :username => "#{node[:ucs][:username]}",
             :password => "#{node[:ucs][:password]}"}.to_json

#JSON Definitions End

#Initialize Objects
ucs_session = UCSToken.new
token_json = ucs_session.get_token(auth_json)
ucs_manage = UCSManage.new(token_json)
#Uncomment to debug
#log token_json

managers = data_bag("managers")
managers.each do |manager_info|
  manager = data_bag_item("managers", manager_info)

  sp_association_json = {:service_profile_boot_policy => "#{manager['service_profile']['service_profile_boot_policy']}",
						 :service_profile_host_fw_policy => "#{manager['service_profile']['service_profile_host_fw_policy']}",
						 :service_profile_mgmt_fw_policy => "#{manager['service_profile']['service_profile_mgmt_fw_policy']}",
						 :service_profile_uuid_pool => "#{manager['service_profile']['service_profile_uuid_pool']}",
						 :service_profile_template_to_bind => "#{manager['service_profile']['service_profile_template_to_bind']}",
						 :service_profile_server_pool => "#{manager['service_profile']['service_profile_server_pool']}",
						 :org => "#{manager['service_profile']['org']}"}.to_json

  ucs_manage.associate_service_profile_template_to_server_pool(sp_association_json)
  #uncomment to debug
  log sp_association_json
  #log "Created  Service Profiles #{service_profile['service_profile_names']}"

end
