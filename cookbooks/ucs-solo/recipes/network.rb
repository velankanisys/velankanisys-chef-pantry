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

#Setup VLANs

networks = data_bag("networks")
networks.each do |network_info|
  network = data_bag_item("networks", network_info)
  vlans_json = {:vlan_id => "#{network['vlan_id']}", :vlan_name => "#{network['vlan_name']}"}.to_json

  ucs_provision.set_vlan(vlans_json)
  #uncomment to debug
  #log vlans_json
  log "Created VLAN #{network['vlan_name']} with ID #{network['vlan_id']}"
  
end
