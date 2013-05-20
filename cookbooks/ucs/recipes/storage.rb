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

auth_json = {:ip => "#{node[:ucs][:ip]}",
             :username => "#{node[:ucs][:username]}",
             :password => "#{node[:ucs][:password]}"}.to_json


#Initialize Objects
ucs_session = UCSToken.new
token_json = ucs_session.get_token(auth_json)
ucs_provision = UCSProvision.new(token_json)
#Uncomment to debug
#log token_json

#Setup VSANs. It is important to note that the FCoE ID cannot conflict with existing
#VLAN IDs. Example, if a VLAN ID of 100 exists already, then the FCoE ID for the VSAN
#will need to use something other than 100

storage = data_bag("storage")
storage.each do |vstorage_info|
  vstorage = data_bag_item("storage", vstorage_info)
  vsans_json = {:vsan_id => "#{vstorage['vsan_id']}", :vsan_fcoe_id => "#{vstorage['vsan_fcoe_id']}",
  				:vsan_name => "#{vstorage['vsan_name']}"}.to_json

  ucs_provision.set_vsan(vsans_json)
  #uncomment to debug
  #log vlans_json
  log "Created VSAN #{vstorage['vsan_name']} with ID #{vstorage['vsan_id']}"
 
end
