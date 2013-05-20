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
ucs_provision = UCSProvision.new(token_json)
#Uncomment to debug
#log token_json

#Set Pools - UUID, Mac, WWPN, WWNN

pools = data_bag("pools")
pools.each do |pool_info|
  pool = data_bag_item("pools", pool_info)
  uuid_pool_json = {:uuid_pool_name => "#{pool['uuid']['name']}", :uuid_from => "#{pool['uuid']['from']}",
                    :uuid_to => "#{pool['uuid']['to']}", :org => "#{pool['uuid']['org']}"}.to_json

  mac_pool_json = {:mac_pool_name => "#{pool['mac']['name']}", :mac_pool_start => "#{pool['mac']['start']}",
                   :mac_pool_end => "#{pool['mac']['end']}", :org => "#{pool['mac']['org']}"}.to_json

  wwpn_pool_json = {:wwpn_name => "#{pool['wwpn']['name']}", :wwpn_from => "#{pool['wwpn']['from']}",
                    :wwpn_to => "#{pool['wwpn']['to']}", :org => "#{pool['wwpn']['org']}"}.to_json

  wwnn_pool_json = {:wwnn_name => "#{pool['wwnn']['name']}", :wwnn_from => "#{pool['wwnn']['from']}",
                    :wwnn_to => "#{pool['wwnn']['to']}", :org => "#{pool['wwnn']['org']}"}.to_json

  server_pool_json = {:server_pool_name => "#{pool['server']['server_pool_name']}", :server_pool_description => "#{pool['server']['server_pool_description']}",
                      :server_pool_chassis_ids => "#{pool['server']['server_pool_chassis_ids']}", :server_pool_blades => "#{pool['server']['server_pool_blades']}",
                      :org => "#{pool['server']['org']}"}.to_json

  ucs_provision.set_uuid_pool(uuid_pool_json)
  log "Created UUID Pool #{pool['uuid']['name']} from #{pool['uuid']['from']} to #{pool['uuid']['to']} in org #{pool['uuid']['org']}"
  ucs_provision.set_mac_pool(mac_pool_json)
  log "Created MAC Pool #{pool['mac']['name']} start #{pool['mac']['start']} end #{pool['mac']['end']} in org #{pool['mac']['org']}"
  ucs_provision.set_wwpn_pool(wwpn_pool_json)
  log "Created WWPN Pool #{pool['wwpn']['name']} from #{pool['wwpn']['from']} to #{pool['wwpn']['to']} in org #{pool['wwpn']['org']}"
  ucs_provision.set_wwnn_pool(wwnn_pool_json)
  log "Created WWNN Pool #{pool['wwnn']['name']} from #{pool['wwnn']['from']} to #{pool['wwnn']['to']} in org #{pool['wwnn']['org']}"
  ucs_provision.set_server_pool(server_pool_json)
  log "Created Server Pool #{pool['server']['server_pool_name']} on chassis #{pool['server']['server_pool_chassis_ids']} using blades #{pool['server']['server_pool_blades']}"
  
  
end
