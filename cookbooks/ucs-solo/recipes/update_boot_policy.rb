#
# Cookbook Name:: ucs
# Recipe:: basic [Toggle Boot Policy after install]
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

#include_recipe 'ucs::firmware'

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
ucs_update = UCSUpdate.new(token_json)
#Uncomment to debug
#log token_json

#Update Boot Policy
ops = data_bag("ops")
ops.each do |op_info|
	boot_policy = data_bag_item("ops", op_info)
	boot_policy_json = {:service_profile_template_name => "#{boot_policy['service_profile_template_name']}",
						:org => "#{boot_policy['org']}",
						:service_profile_template_mgmt_ip_pool => "#{boot_policy['service_profile_template_mgmt_ip_pool']}",
						:service_profile_template_boot_policy => "#{boot_policy['service_profile_template_boot_policy']}",
						:service_profile_template_host_fw_policy => "#{boot_policy['service_profile_template_host_fw_policy']}",
						:service_profile_template_uuid_pool => "#{boot_policy['service_profile_template_uuid_pool']}"
					}.to_json

ucs_update.update_boot_policy_on_service_profile_template(boot_policy_json)
log "Updated boot policy of Service Profile Template #{boot_policy['service_profile_template_name']} to #{boot_policy['service_profile_template_boot_policy']}"
end




