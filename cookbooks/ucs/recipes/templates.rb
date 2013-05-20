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

#Setup vNIC Templates

networktemplates = data_bag("networktemplates")
networktemplates.each do |network_template_info|
  networktemplate = data_bag_item("networktemplates", network_template_info)
  vnic_templates_json = {:vnic_template_name => "#{networktemplate['vnic_template_name']}",
						 :vnic_template_mac_pool => "#{networktemplate['vnic_template_mac_pool']}",
						 :switch => "#{networktemplate['switch']}",
						 :vnic_template_VLANs => "#{networktemplate['vnic_template_VLANs']}",
						 :vnic_template_native_VLAN => "#{networktemplate['vnic_template_native_VLAN']}",
						 :vnic_template_mtu => "#{networktemplate['vnic_template_mtu']}",
						 :org => "#{networktemplate['org']}"}.to_json

  ucs_provision.set_vnic_template(vnic_templates_json)
  #uncomment to debug
  #log vnic_templates_json
  log "Created  vNIC Template #{networktemplate['vnic_template_name']}"
  
end

#Setup vHBA Templates

storagetemplates = data_bag("storagetemplates")
storagetemplates.each do |storage_template_info|
  storagetemplate = data_bag_item("storagetemplates", storage_template_info)
  vhba_templates_json = {:vhba_template_name => "#{storagetemplate['vhba_template_name']}",
  						 :description => "#{storagetemplate['description']}",
						 :wwpn_pool => "#{storagetemplate['wwpn_pool']}",
						 :switch => "#{storagetemplate['switch']}",
						 :vsan_name => "#{storagetemplate['vsan_name']}",
						 :org => "#{storagetemplate['org']}"}.to_json

  ucs_provision.set_vhba_template(vhba_templates_json)
  #uncomment to debug
  #log vhba_templates_json
  log "Created  vHBA Template #{storagetemplate['vhba_template_name']}"
  
end


#Setup Service Profile Templates

service_profile_templates = data_bag("serviceprofiletemplates")
service_profile_templates.each do |service_profile_template_info|
  service_profile_template = data_bag_item("serviceprofiletemplates", service_profile_template_info)
  service_profile_templates_json = {:service_profile_template_name => "#{service_profile_template['service_profile_template_name']}",
  									:service_profile_template_boot_policy => "#{service_profile_template['service_profile_template_boot_policy']}",
  									:service_profile_template_host_fw_policy => "#{service_profile_template['service_profile_template_host_fw_policy']}",
  									:service_profile_template_mgmt_fw_policy => "#{service_profile_template['service_profile_template_mgmt_fw_policy']}",
  									:service_profile_template_uuid_pool => "#{service_profile_template['service_profile_template_uuid_pool']}",
  									:service_profile_template_vnics_a => "#{service_profile_template['service_profile_template_vnics_a']}",
  									:service_profile_template_vnic_a_template => "#{service_profile_template['service_profile_template_vnic_a_template']}",
  									:service_profile_template_vnics_b => "#{service_profile_template['service_profile_template_vnics_b']}",
  									:service_profile_template_vnic_b_template => "#{service_profile_template['service_profile_template_vnic_b_template']}",
  									:service_profile_template_wwnn_pool => "#{service_profile_template['service_profile_template_wwnn_pool']}",
  									:service_profile_template_vhba_a => "#{service_profile_template['service_profile_template_vhba_a']}",
  									:service_profile_template_vhba_a_template => "#{service_profile_template['service_profile_template_vhba_a_template']}",
  									:service_profile_template_vhba_b => "#{service_profile_template['service_profile_template_vhba_b']}",
  									:service_profile_template_vhba_b_template => "#{service_profile_template['service_profile_template_vhba_b_template']}",
  									:org => "#{service_profile_template['org']}"}.to_json

  ucs_provision.set_service_profile_template(service_profile_templates_json)
  #uncomment to debug
  #log vhba_templates_json
  log "Created  Service Profile Template #{service_profile_template['service_profile_template_name']}"
  
end
