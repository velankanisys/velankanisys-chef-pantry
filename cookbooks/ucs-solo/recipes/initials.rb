#
# Cookbook Name:: ucs
# Recipe:: initial [Setup initial Environment]
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

#include_recipe 'ucs-solo::default'

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

#initial Setup - For example using initial1.json data bag

initials = data_bag("initials")
initials.each do |initial_info|
  initial = data_bag_item("initials", initial_info)

  timezone_json = {:time_zone => "#{initial['time_zone']}"}.to_json

  power_policy_json = {:power_policy => "#{initial['power_policy']}"}.to_json

  chassis_discovery_policy_json = {:chassis_discovery_policy =>
                                       "#{initial['chassis_discovery_policy']}"}.to_json

  local_disk_policy_json = {:local_disk_policy => "#{initial['local_disk_policy']}"}.to_json

  mgmt_ip_pool_json = {:start_ip => "#{initial['mgmt_ip_pool']['start_ip']}",
                       :end_ip => "#{initial['mgmt_ip_pool']['end_ip']}",
                       :subnet_mask => "#{initial['mgmt_ip_pool']['subnet_mask']}",
                       :gateway => "#{initial['mgmt_ip_pool']['gateway']}"}.to_json

  syslog_json = {:syslog_server => "#{initial['syslog']['syslog_server']}",
                 :facility => "#{initial['syslog']['facility']}",
                 :severity => "#{initial['syslog']['severity']}"}.to_json

  ntp_servers = "#{initial['ntp']}".split(",")
  ntp_servers.each do |server|
    ntp_server_json = {:ntp_server => "#{server}"}.to_json
    ucs_provision.set_ntp_server(ntp_server_json)
    log ntp_server_json
  end

  ucs_provision.set_time_zone(timezone_json)
  log timezone_json

  ucs_provision.set_power_policy(power_policy_json)
  log power_policy_json

  ucs_provision.set_chassis_discovery_policy(chassis_discovery_policy_json)
  log chassis_discovery_policy_json

  ucs_provision.set_local_disk_policy(local_disk_policy_json)
  log local_disk_policy_json

  ucs_provision.set_management_ip_pool(mgmt_ip_pool_json)
  log mgmt_ip_pool_json

  ucs_provision.set_syslog_server(syslog_json)
  log syslog_json
end

orgs = data_bag("orgs")
orgs.each do |org_info|
  org = data_bag_item("orgs", org_info)
  org_json = {:org => "#{org['org']}", :description => "#{org['description']}"}.to_json
  ucs_provision.set_org(org_json)
  log org_json
end





