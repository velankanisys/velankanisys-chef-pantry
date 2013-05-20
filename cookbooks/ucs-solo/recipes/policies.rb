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
ucs_provision = UCSProvision.new(token_json)
#Uncomment to debug
#log token_json


#Set Policies
policies = data_bag("policies")
policies.each do |policy_info|
  policy = data_bag_item("policies", policy_info)

  sanboot_policy_json = {:name => "#{policy['SANBoot']['name']}", :type => "#{policy['SANBoot']['type']}",
                         :description => "#{policy['SANBoot']['description']}", :org => "#{policy['SANBoot']['org']}",
                         :vhba_a => "#{policy['SANBoot']['vhba_a']}", :vhba_b => "#{policy['SANBoot']['vhba_b']}",
                         :target_a_1 => "#{policy['SANBoot']['target_a_1']}", :target_a_2 => "#{policy['SANBoot']['target_a_2']}",
                         :target_b_1 => "#{policy['SANBoot']['target_b_1']}", :target_b_2 => "#{policy['SANBoot']['target_b_2']}"}.to_json

  localboot_policy_json = {:name => "#{policy['LocalBoot']['name']}", :type => "#{policy['LocalBoot']['type']}",
                           :description => "#{policy['LocalBoot']['description']}", :org => "#{policy['LocalBoot']['org']}"}.to_json


  pxeboot_policy_json = {:name => "#{policy['PXEBoot']['name']}", :type => "#{policy['PXEBoot']['type']}",
                         :description => "#{policy['PXEBoot']['description']}", :org => "#{policy['PXEBoot']['org']}",
                         :vnic_a => "#{policy['PXEBoot']['vnic_a']}", :vnic_b => "#{policy['PXEBoot']['vnic_b']}"}.to_json

  ucs_provision.set_san_boot_policy(sanboot_policy_json)
  log "Created SAN boot policy #{policy['SANBoot']['name']} in org #{policy['SANBoot']['org']}"
  #uncomment to debug
  #log policy_json
  ucs_provision.set_local_boot_policy(localboot_policy_json)
  log "Created local boot policy #{policy['LocalBoot']['name']} in org #{policy['LocalBoot']['org']}"
  #uncomment to debug
  #log localboot_json
  ucs_provision.set_pxe_boot_policy(pxeboot_policy_json)
  log "Created PXE boot policy #{policy['PXEBoot']['name']} in org #{policy['PXEBoot']['org']}"
  #uncomment to debug
  #log pxeboot_json

end
